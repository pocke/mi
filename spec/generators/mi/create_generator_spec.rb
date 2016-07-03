require 'spec_helper'

describe Mi::Generators::CreateGenerator, :with_doing do
  context 'when add a column' do
    let(:arguments){%w[users +email:string]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has `add_column`' do
      subject
      migration_file_include? 't.string :email'
    end

    it 'filename is `create_users_table`' do
      subject
      is_asserted_by{ last_migration_file.end_with?('create_users_table.rb') }
    end
  end

  context 'when type is not specified' do
    let(:arguments){%w[users +email]}

    it 'should raise error' do
      expect{subject}.to raise_error Mi::Generators::CreateGenerator::TypeIsRequired
    end
  end
end
