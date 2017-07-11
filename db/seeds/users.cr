module Seeds::Users
  extend self

  def user(**params)
    User.create(params.to_h)
  end

  def create_records
    user login: "veelenga",
      name: "V. Elenhaupt",
      provider: "github",
      uid: "111111"

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
