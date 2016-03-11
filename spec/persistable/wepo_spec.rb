require 'spec_helper'

describe Missile::Persistable::Wepo do
  describe '.repo' do
    context 'when configuring with block' do
      let(:command_class) do
        model_class = double(:model_class)
        entity_class = double(:entity_class)

        Class.new(Missile::Command) do
          include Missile::Persistable::Wepo
          repo do
            model model_class
            entity entity_class
          end
        end
      end
      it 'configures the repo class' do
        expect(command_class.repo_class).to respond_to :entity_class
        expect(command_class.repo_class).to respond_to :entity
        expect(command_class.repo_class).to respond_to :model_class
        expect(command_class.repo_class).to respond_to :model
      end
    end

    context 'when configuring with class' do

      let(:repo_class) do
        model_class = double(:model_class)
        entity_class = double(:entity_class)
        Class.new do
          include ::Wepo::Repo
          model model_class
          entity entity_class
        end
      end

      let(:command_class) do
        RepoClass = repo_class
        Class.new(Missile::Command) do
          include Missile::Persistable::Wepo
          repo RepoClass
        end
      end


      let(:command) { command_class.new({}) }

      it 'configures the repo class' do
        expect(command_class.repo_class).to eq repo_class
        expect(command_class.repo_class).to respond_to :entity_class
        expect(command_class.repo_class).to respond_to :entity
        expect(command_class.repo_class).to respond_to :model_class
        expect(command_class.repo_class).to respond_to :model
      end

      it 'exposes the repo instance methods' do
        expect(command).to respond_to :save
        expect(command).to respond_to :create
        expect(command).to respond_to :update
        expect(command).to respond_to :find_or_initialize_by
        expect(command).to respond_to :where
      end
    end
  end
end
