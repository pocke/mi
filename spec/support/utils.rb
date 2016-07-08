module UtilsInclude
  def last_migration_file
    Dir.glob(Pathname.new(SPEC_TMP_DPR)/'db/migrate/*.rb').sort.last
  end

  def migration_file_include?(expected)
    got = File.read(last_migration_file)
    is_asserted_by{ got.include? expected }
  end
end

module UtilsExtend
  shared_examples 'should_valid_as_a_ruby_script' do
    it 'should valid as a ruby script' do
      subject
      rb = File.read(last_migration_file)
      rip = Class.new(Ripper) do
        def on_parse_error(msg)
          raise msg
        end
      end
      rip.parse(rb)
    end
  end

  shared_context 'With doing', :with_doing do
    let(:test_case){Class.new(Rails::Generators::TestCase)}
    subject{test_case.new(:doing).run_generator(arguments)}
    before do
      test_case.tests described_class
      test_case.destination_root = SPEC_TMP_DPR
    end

    after do
      FileUtils.remove_entry_secure(Pathname.new(SPEC_TMP_DPR)/'db/migrate/')
    end
  end

  shared_examples 'open_a_editor_when_edit_option' do
    context 'when has a --edit option' do
      let(:arguments){%w[users +email:string --edit]}

      it 'should open a editor' do
        editor = ENV['EDITOR'] || 'vim'
        expect_any_instance_of(Object).to receive(:system).with(editor, String)
        subject
      end
    end
  end
end
