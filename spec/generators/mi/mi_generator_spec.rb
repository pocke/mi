require 'spec_helper'

describe Mi::Generators::MiGenerator, :with_doing do
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

  include_examples 'open_a_editor_when_edit_option'
  include_examples 'with_rails_version'
  include_examples 'with_version_option'
end
