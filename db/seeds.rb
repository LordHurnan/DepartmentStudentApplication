require "faker"

Faker::Config.random = Random.new(20261106)

40.times do |i|
  number = i + 1

  # Alternate between Computer Engineering and Electronics Engineering.
  department_name = i.even? ? "Computer Eng" : "Elect Eng"
  program = i.even? ? "BsCpE" : "BsEcE"
  subject_name = i.even? ? "Database" : "Elecs"

  department = Department.find_by!(name: department_name)
  subject = Subject.find_by!(name: subject_name)

  # Generate normal student names without titles or Faker tags.
  clean_name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"

  # Find the old tagged student, or an already-cleaned student.
  marker = "[FAKER-STUDENT-#{number}]"
  student = Student.where("name LIKE ?", "%#{marker}").first
  student ||= Student.find_or_initialize_by(name: clean_name)

  student.update!(
    name: clean_name,
    department: department,
    program: program
  )

  # Keep existing enrollment if the student already has this subject.
  existing_enrollment = student.classlists
    .joins(:section)
    .find_by(sections: { subject_id: subject.id })

  unless existing_enrollment
    section = Section.where(subject: subject)
      .order(:student_count, :id)
      .first!

    Classlist.create!(
      student: student,
      section: section
    )
  end
end

# Correct department counters in case older callbacks counted twice.
Department.find_each do |department|
  Department.reset_counters(department.id, :students)
end

puts "Faker student updates completed!"
puts "Total students: #{Student.count}"