class HomeController < ApplicationController
  def index
    @student_count = Student.count
    @teacher_count = Teacher.count
    @department_count = Department.count
    @subject_count = Subject.count
    @section_count = Section.count
    @laboratory_count = Laboratory.count
    @classlist_count = Classlist.count

    @teachers = Teacher.includes(:department).limit(3)
  end
end
