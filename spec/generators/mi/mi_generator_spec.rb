require 'spec_helper'

describe MiGenerator do
  let(:test_case){Class.new(Rails::Generators::TestCase)}
  subject{test_case.new(:doing).run_generator(arguments)}
  before do
    test_case.tests described_class
    test_case.destination_root = SPEC_TMP_DPR
  end

  let(:last_migration_file){Dir.glob(Pathname.new(SPEC_TMP_DPR)/'db/migrate/*.rb').last}

  after do
    FileUtils.remove_entry_secure(Pathname.new(SPEC_TMP_DPR)/'db/migrate/')
  end

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

  context 'when add a column' do
    let(:arguments){%w[users +email:string]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has `add_column`' do
      subject
      is_asserted_by{ File.read(last_migration_file).include? 'add_column :users, :email, :string' }
    end
  end

  context 'when remove a column' do
    let(:arguments){%w[users -email]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has `remove_column`' do
      subject
      is_asserted_by{ File.read(last_migration_file).include? 'remove_column :users, :email' }
    end
  end
end
