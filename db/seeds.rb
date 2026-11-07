require "faker"

sample_subjects = [
  {
    subject_name: "database",
    department_name: "Computer Engineering",
    program: "BsCpE"
  },
  {
    subject_name: "QCPA211",
    department_name: "Electronics Engineering",
    program: "BsEcE"
  }
]

sample_subjects.each_with_index do |sample, index|
  subject = Subject
    .joins(teacher: :department)
    .where("LOWER(TRIM(subjects.name)) = ?", sample[:subject_name].downcase)
    .where("LOWER(TRIM(departments.name)) = ?", sample[:department_name].downcase)
    .first!

  department = subject.teacher.department

  20.times do |i|
    number = (index * 20) + i + 1
    identifier = "FAKER-STUDENT-#{number}"

    Faker::Config.random = Random.new(20261106 + number)

    clean_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"

    student = Student.find_or_initialize_by(
      faker_identifier: identifier
    )

    student.update!(
      name: clean_name,
      department: department,
      program: sample[:program]
    )

    existing_enrollment = student.classlists
      .joins(:section)
      .find_by(sections: { subject_id: subject.id })

    unless existing_enrollment
      section = subject.sections
        .order(:student_count, :id)
        .first!

      Classlist.create!(
        student: student,
        section: section
      )
    end
  end
end

Department.find_each do |department|
  Department.reset_counters(department.id, :students)
end

puts "Faker sample data generated successfully!"
puts "Total students: #{Student.count}"
puts "Faker students: #{Student.where.not(faker_identifier: nil).count}"