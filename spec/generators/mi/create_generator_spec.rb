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

  context 'when has a option' do
    let(:arguments){%w[users +email:string:{null:false}]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has a `null: false`' do
      subject
      migration_file_include? 't.string :email, null: false'
    end
  end

  context 'when type is not specified' do
    let(:arguments){%w[users +email]}

    it 'should raise error' do
      expect{subject}.to raise_error Mi::Generators::CreateGenerator::TypeIsRequired
    end
  end

  context 'when has a remove column' do
    let(:arguments){%w[users -email:string]}

    it 'should raise error' do
      expect{subject}.to raise_error Mi::Generators::CreateGenerator::NotAllowMethod
    end
  end

  context 'when has a change column' do
    let(:arguments){%w[users %email:string]}

    it 'should raise error' do
      expect{subject}.to raise_error Mi::Generators::CreateGenerator::NotAllowMethod
    end
  end

  include_examples 'open_a_editor_when_edit_option'
  include_examples 'with_rails_version'
  include_examples 'with_version_option'
end
