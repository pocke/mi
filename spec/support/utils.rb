module UtilsInclude
  def last_migration_file
    Dir.glob(Pathname.new(SPEC_TMP_DPR)/'db/migrate/*.rb').sort.last
  end

  def migration_file_include?(expected)
    got = File.read(last_migration_file)
    is_asserted_by{ got.include? expected }
  end
end
