require 'spec_helper'

describe MiGenerator do
  let(:test_case){Class.new(Rails::Generators::TestCase)}
  subject{test_case.new(:doing).run_generator(arguments)}
  before do
    test_case.tests described_class
    test_case.destination_root = SPEC_TMP_DPR
  end

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
      migration_file_include? 'add_column :users, :email, :string'
    end

    it 'has to in filename' do
      subject
      is_asserted_by{ last_migration_file.end_with?('to_users.rb') }
    end
  end

  context 'when remove a column' do
    let(:arguments){%w[users -email]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has `remove_column`' do
      subject
      migration_file_include? 'remove_column :users, :email'
    end

    it 'has from in filename' do
      subject
      is_asserted_by{ last_migration_file.end_with?('from_users.rb') }
    end
  end

  context 'when change column' do
    let(:arguments){%w[users %email:string:{null:true}]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'should has change_column' do
      subject
      migration_file_include? 'change_column :users, :email, :string, null: true'
    end

    it 'has from in filename' do
      subject
      is_asserted_by{ last_migration_file.end_with?('of_users.rb') }
    end
  end

  context 'when add a column with not null' do
    let(:arguments){%w[users +email:string:{null:false,default:"foo@example.com"}]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has null false' do
      subject
      migration_file_include? 'add_column :users, :email, :string, null: false, default: "foo@example.com"'
    end
  end
end
