module Seeds::Users
  extend self

  def user(**params)
    User.new(params.to_h).tap &.save
  end

  def create_records
    user login: "veelenga",
      name: "V. Elenhaupt",
      provider: "github",
      uid: "111111",
      role: "admin"

    user login: "ann",
      name: "Ann Doe",
      provider: "github",
      uid: "22222"

    user login: "joe",
      name: "Joe Doe",
      provider: "github",
      uid: "33333"
  end
end
