class CreateUser < Missile::Command
  include Validateable

  contract do
    feature Reform::Form::Dry

    property :first_name
    property :last_name
    property :email
    property :password
    property :password_confirmation
  end

  def run(params)
    errors = validate(model, params) { model.save }
    self
  end
end
