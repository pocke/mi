require 'spec_helper'

describe Mi::Generators::MiGenerator do
  context 'when add a column', :with_doing do
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

  context 'when remove a column', :with_doing do
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

  context 'when change column', :with_doing do
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

  context 'when add a column with not null', :with_doing do
    let(:arguments){%w[users +email:string:{null:false,default:"foo@example.com"}]}

    include_examples 'should_valid_as_a_ruby_script'

    it 'has null false' do
      subject
      migration_file_include? 'add_column :users, :email, :string, null: false, default: "foo@example.com"'
    end
  end
end
