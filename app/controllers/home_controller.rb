class HomeController < ApplicationController
  def index
    # Dashboard counts
    @student_count = Student.count
    @teacher_count = Teacher.count
    @department_count = Department.count
    @subject_count = Subject.count
    @section_count = Section.count
    @laboratory_count = Laboratory.count
    @classlist_count = Classlist.count

    # Faculty members
    @teachers = Teacher.includes(:department).limit(6)

    # Chart data: Students by department
    @students_by_department = Student.joins(:department)
                                     .group("departments.name")
                                     .count

    # Chart data: Students by program
    @students_by_program = Student.where.not(program: [nil, ""])
                                  .group(:program)
                                  .count
  end
end