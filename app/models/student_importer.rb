class StudentImporter
  Result = Struct.new(:imported, :skipped, keyword_init: true)

  def initialize(file)
    @file = file
  end

  def call
    extension = File.extname(@file.original_filename).delete(".").downcase.to_sym
    sheet = Roo::Spreadsheet.open(@file.path, extension: extension)
    headers = sheet.row(1).map { |h| h.to_s.strip.downcase }
    departments = Department.all.index_by { |d| d.name.to_s.strip.downcase }

    imported = 0
    skipped = []

    (2..sheet.last_row).each do |i|
      row = headers.zip(sheet.row(i)).to_h
      next if row.values.all?(&:blank?)

      year = row["year_level"]
      year = year.to_i if year.is_a?(Float) && (year % 1).zero?

      student = Student.new(
        name: row["name"].to_s.strip,
        year_level: year,
        program: row["program"].to_s.strip,
        department: departments[row["department"].to_s.strip.downcase]
      )

      if student.save
        imported += 1
      else
        skipped << "Row #{i} (#{row['name']}): #{student.errors.full_messages.to_sentence}"
      end
    end

    Result.new(imported: imported, skipped: skipped)
  end
end