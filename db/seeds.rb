require "faker"

data = [
  {
    name: "Computer Engineering",
    location: "Engineering Building, 2nd Floor",
    program: "BsCpE",
    laboratories: [ "Computer Lab 1", "Networking Lab", "Embedded Systems Lab" ],
    teachers: [
      {
        name: "Maria Santos", email: "maria.santos@example.edu",
        specialization: "Databases", per_unit_rate: 800,
        subjects: [ [ "database", 3 ], [ "Data Structures", 3 ] ]
      },
      {
        name: "Jose Reyes", email: "jose.reyes@example.edu",
        specialization: "Operating Systems", per_unit_rate: 750,
        subjects: [ [ "Operating Systems", 3 ] ]
      }
    ]
  },
  {
    name: "Electronics Engineering",
    location: "Engineering Building, 3rd Floor",
    program: "BsEcE",
    laboratories: [ "Circuits Lab", "Communications Lab" ],
    teachers: [
      {
        name: "Ana Cruz", email: "ana.cruz@example.edu",
        specialization: "Circuit Theory", per_unit_rate: 800,
        subjects: [ [ "QCPA211", 3 ], [ "Circuits", 4 ] ]
      },
      {
        name: "Pedro Lim", email: "pedro.lim@example.edu",
        specialization: "Signals", per_unit_rate: 700,
        subjects: [ [ "Signals and Systems", 3 ] ]
      }
    ]
  }
]

student_number = 0

data.each do |dept_data|
  department = Department.find_or_create_by!(name: dept_data[:name]) do |d|
    d.location = dept_data[:location]
  end

  dept_data[:laboratories].each do |lab_name|
    department.laboratories.find_or_create_by!(name: lab_name) do |lab|
      lab.location = dept_data[:location]
    end
  end

  subjects = []

  dept_data[:teachers].each do |t|
    teacher = Teacher.find_or_create_by!(email: t[:email]) do |record|
      record.name = t[:name]
      record.specialization = t[:specialization]
      record.per_unit_rate = t[:per_unit_rate]
      record.department = department
    end

    t[:subjects].each do |subject_name, units|
      subject = Subject.find_or_create_by!(name: subject_name, teacher: teacher) do |s|
        s.number_of_units = units
        s.per_unit_rate = 1500.0
      end

      [ "A", "B" ].each_with_index do |suffix, i|
        subject.sections.find_or_create_by!(name: "#{subject_name}-#{suffix}") do |section|
          section.room = "Room #{101 + i}"
          section.timeslot = i.zero? ? "MWF 8:00-9:00" : "TTh 10:00-11:30"
        end
      end

      subjects << subject
    end
  end

  20.times do
    student_number += 1
    identifier = "FAKER-STUDENT-#{student_number}"

    Faker::Config.random = Random.new(20261106 + student_number)
    clean_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"

    student = Student.find_or_initialize_by(faker_identifier: identifier)
    student.update!(
      name: clean_name,
      department: department,
      program: dept_data[:program],
      year_level: Faker::Number.between(from: 1, to: 4)
    )

    subjects.each do |subject|
      already_enrolled = student.classlists
        .joins(:section)
        .exists?(sections: { subject_id: subject.id })
      next if already_enrolled

      section = subject.sections.order(:student_count, :id).first!
      Classlist.create!(student: student, section: section)
    end
  end
end

# Safety net: make sure the cached counters match reality
Department.find_each do |d|
  d.update_columns(
    students_count: d.students.count,
    teachers_count: d.teachers.count,
    laboratory: d.laboratories.count
  )
end

puts "Seed complete!"
puts "Departments: #{Department.count}, Teachers: #{Teacher.count}, Subjects: #{Subject.count}"
puts "Sections: #{Section.count}, Students: #{Student.count}, Enrollments: #{Classlist.count}"