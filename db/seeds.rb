Laboratory.destroy_all
Teacher.destroy_all
Student.destroy_all
Department.destroy_all

computer_Eng = Department.create!(
  name: "Department of CpE",
  location: "Dolan Building, 4th Floor"
)

elec_Eng = Department.create!(
  name: "Department of EcE",
  location: "Dolan Building, 4th Floor"
)

#CpE Students

Student.create!(
  name: "Hurnan Bersabe",
  year_level: 3,
  program: "BS CpE",
  department: computer_Eng
)

Student.create!(
  name: "Kenneth Sarmiento",
  year_level: 3,
  program: "BS CpE",
  department: computer_Eng
)

Student.create!(
  name: "JB Rafael",
  year_level: 3,
  program: "BS CpE",
  department: computer_Eng
)

# EcE Students

Student.create!(
  name: "John Benedict",
  year_level: 3,
  program: "BS EcE",
  department: elec_Eng
)

Student.create!(
  name: "Juan Sabino",
  year_level: 3,
  program: "BS EcE",
  department: elec_Eng
)

Student.create!(
  name: "Daniel Ramos",
  year_level: 3,
  program: "BS EcE",
  department: elec_Eng
)

# Teachers

Teacher.create!(
  name: "ma'am Karla Sobrevilla",
  email: "ma'amKarla@gmail.com",
  specialization: "Master in CpE",
  department: computer_Eng
)

Teacher.create!(
  name: "Sir, Anacleto Casimiro",
  email: "sirNaki@gmail.com",
  specialization: "Master in EcE",
  department: elec_Eng
)

# Comp Laboratories
Laboratory.create!(
  name: "Cisco Laboratory",
  location: "Dolan Building, 4th Floor",
  department: computer_Eng
)

Laboratory.create!(
  name: "General Computer Laboratory",
  location: "Dolan Building, 3rd Floor",
  department: computer_Eng
)

# Elect Laboratories
Laboratory.create!(
  name: "Workshop Laboratory",
  location: "Dolan Building, 3rd Floor",
  department: elec_Eng
)

Laboratory.create!(
  name: "Electronics Laboratory",
  location: "Dolan Building, 3rd Floor",
  department: elec_Eng
)

puts "Database seeded successfully!"
puts "Departments: #{Department.count}"
puts "Students: #{Student.count}"
puts "Teachers: #{Teacher.count}"
puts "Laboratories: #{Laboratory.count}"