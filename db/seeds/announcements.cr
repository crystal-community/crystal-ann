module Seeds::Announcements
  extend self

  def announcement(typename, **params)
    type = Announcement::TYPES
      .find { |k, v| v == typename }
      .try(&.first) || 0

    attributes = {:type => type} of Symbol => Int32 | String
    Announcement.create(attributes.merge!(params.to_h)).tap do |a|
      a.created_at = rand(15).days.ago - rand(60).minutes
      a.save
    end
  end

  def create_records
    announcement "Project Update",
      title: "Linear algebra library based on LAPACK",
      description: <<-DE
        https://github.com/konovod/linalg

        Linear algebra library in Crystal, uses LAPACKE:

          * direct access to LAPACK methods
          * convenient Matrix(T) class, supports T=Float32, Float64 and Complex.
          * high-level interface similar to scipy.linalg or MATLAB.

        Killing SciPy, one module at a time.
        DE

    announcement "Blog Post",
      title: "Methods tap and itself in Crystal",
      description: <<-DE
        http://veelenga.com/tap-and-itself-methods-in-crystal/

        Method [Object#tap](https://crystal-lang.org/api/0.23.0/Object.html#tap%28%26block%29-instance-method) in Crystal yields to the block and then returns self.
        [Object#itself](https://crystal-lang.org/api/0.23.0/Object.html#itself-instance-method) just returns self.
        Why do we need those methods? Let’s look at few examples.
        DE

    announcement "Blog Post",
      title: "Observer design pattern in Crystal language",
      description: <<-DE
        http://veelenga.com/observer-design-pattern-in-crystal-language/

        Being a developer you probably have heart about Observer design pattern.
        Perhaps, you have even used it in your complex system with subscribers and notifications.
        This article is about how to implement Observer pattern in Crystal language and what are the common features of this language we can use there to tune it.

        ```crystal
        # Sample
        fighter = Fighter.new("Scorpion")

        fighter.add_observer(Stats.new)
        fighter.add_observer(DieAction.new)

        fighter.damage(10)
        # Updating stats: Scorpion's health is 90

        fighter.damage(30)
        # Updating stats: Scorpion's health is 60

        fighter.damage(75)
        # Updating stats: Scorpion's health is 0
        # Scorpion is dead. Fight is over!
        ```
        DE

    announcement "Blog Post",
      title: "Make your own Shard in Crystal language",
      description: <<-DE
        http://veelenga.com/make-your-own-shard-in-crystal-language/

        An easy to use tutorial that describes how to create a new shard in Crystal language.

        Here you will find how to add an executable, project dependencies, write tests and document your code.
        DE

    announcement "Meetup",
      title: "Crystal Code Camp 2017",
      description: <<-DE
        Crystal Code Camp 2017 is taking place in San Francisco. See you there ;)

        Checkout our home page for details: https://codecamp.crystal-lang.org/

        Learn, engage and share.
        DE

    announcement "Project Update",
      title: "Crystal bindings to Lua and a wrapper around it",
      description: <<-DE
        ![](https://github.com/veelenga/bin/raw/master/lua.cr/logo.jpg)

        Crystal bindings to Lua and a wrapper around it: [https://github.com/veelenga/lua.cr](https://github.com/veelenga/lua.cr)

        ### Running chunk of Lua code:

        ```crystal
        Lua.run %q{
          local hello_message = table.concat({ 'Hello', 'from', 'Lua!' }, ' ')
          print(hello_message)
        } # => prints 'Hello from Lua!'
        ```

        ### Running Lua file:

        ```crystal
        p Lua.run File.new("./examples/sample.lua") # => 42.0
        ```

        ### Evaluate a function and pass arguments in:

        ```crystal
        lua = Lua.load
        sum = lua.run %q{
          function sum(x, y)
            return x + y
          end

          return sum
        }
        p sum.as(Lua::Function).call(3.2, 1) # => 4.2
        lua.close
        ```

        More features coming soon. Try it, that's fun :)
        DE

    announcement "Project Update",
      title: " Message Queue written in Crystal, very similar to NSQ",
      description: <<-DE
        https://github.com/crystalmq/crystalmq

        To run this project you will need three components.

        * A Message Router, running with either debug set to true or false

          `crystal router.cr false`

        * A Message Consumer, with a topic and channel set

          `crystal tools/consumer.cr my_topic my_channel`

        * A Message Producer, with a topic and message

          `crystal tools/producer.cr my_topic "Hello World"`

        * If you would like to run the benchmarks, feel free to use tools/meth

        ```
        ./meth --consumer # Will benchmark received messags (used in conjuction with producer)
        ./meth --producer # Will benchmark sent messages (used in conjunction with consumer)
        ./meth --latency  # Will benchmark request latency
        ```
        DE

    announcement "Project Update",
      title: "FANN (Fast Artifical Neural Network) binding in Crystal",
      description: <<-DE
        [Crystal bindings for the FANN C lib](https://github.com/bararchy/crystal-fann)

        ```crystal
        require "crystal-fann"
        ann = Crystal::Fann::Network.new 2, [2], 1
        500.times do
          ann.train_single [1.0_f32, 0.1_f32], [0.5_f32]
        end

        result = ann.run [1.0_f32, 0.1_f32]

        ann.close
        ```
        DE

    announcement "Other",
      title: "CrystalShards has reached 2000 shards!",
      description: <<-DE
        ![](https://pbs.twimg.com/media/DD6wVD-UAAEAk87.jpg)

        Search your project at [crystalshards.xyz](http://crystalshards.xyz/)
        DE

    announcement "Blog Post",
      title: "Crystal and Kemal for dynamic website",
      description: <<-DE
        ![](https://cdn-images-1.medium.com/max/1440/1*9veJjTBa0xuhyO67pJHnYQ.png)

        [Second part](https://medium.com/@codelessfuture/crystal-and-kemal-for-dynamic-website-9b853481c88) of Crystal and Kemal pair for creating a dynamic website. Here you will find how to work with static files and layouts.

        In the [first article](https://hackernoon.com/starting-a-project-with-crystal-and-kemal-90e2647e6c3b) we prepare the development environment and made our hands dirty of the first lines of code.
        DE

    announcement "Project Update",
      title: "Crystal 0.23.0 has been released",
      description: <<-DE
        ![](https://cloud.githubusercontent.com/assets/209371/13291809/022e2360-daf8-11e5-8be7-d02c1c8b38fb.png)

        [This release](https://github.com/crystal-lang/crystal/releases/tag/0.23.0) has been built with **LLVM 3.8**.

        As discussed in crystal-lang/omnibus-crystal#17, that means dropping support for Debian 7, and CentOS. Users on those platforms can still build from source using **LLVM 3.5**, but that's not recommended since it's buggy (see #4104).

        * **(breaking-change)** `Logger#formatter` takes a `Severity` instead of a `String` (See #4355, #4369, thanks @Sija)
        * **(breaking-change)** Removed `IO.select` (See #4392, thanks @RX14)
        * Added `Crystal::System::Random` namespace (See #4450, thanks @ysbaddaden)
        * Added `Path#resolve?` macro method (See #4370, #4408, thanks @RX14)
        * Added range methods to `BitArray` (See #4397, #3968, thanks @RX14)
        * Added some well-known HTTP Status messages (See #4419, thanks @akzhan)
        * Added compiler progress indicator (See #4182, thanks @RX14)
        * Added `System.cpu_cores` (See #4449, #4226, thanks @miketheman)
        * Added `separator` and `quote_char` to `CSV#each_row` (See #4448, thanks @timsu)
        * Added `map_with_index!` to `Pointer`, `Array` and `StaticArray` (See #4456, #3356, #3354, thanks @Nephos)
        * Added `headers` parameter to `HTTP::WebSocket` constructors (See #4227, #4222, thanks @adamtrilling)
        * `HTTP::StaticFileHandler` can disable directory listing (See #4403, #4398, thanks @joaodiogocosta)
        * `bin/crystal` now uses `/bin/sh` instead of `/bin/bash` (See #3809, #4410, thanks @TheLonelyGhost)
        * `crystal init` generates a `.editorconfig` file (See #4422, #297, thanks @akzhan)
        * `man` page for `crystal` command (See #2989, #1291, thanks @dread-uo)
        * Re-raising an exception doesn't overwrite its callstack (See #4487, #4482, thanks @akzhan)
        * MD5 and SHA1 documentation clearly states they are not cryptographically secure anymore (See #4426, thanks @RX14)
        * Fixed Crystal not reusing .o files across builds (See #4336)
        * Fixed `SomeClass.class.is_a?(SomeConst)` causing an "already had enclosing call" exception (See #4364, #4390, thanks @rockwyc992)
        * Fixed `HTTP::Params.parse` query string with two `=` gave wrong result (See #4388, #4389, thanks @akiicat)
        * Fixed `Class.class.is_a?(Class.class.class.class.class)`  (See #4375, #4374, thanks @rockwyc992)
        * Fixed select hanging when sending before receive (See #3862, #3899, thanks @kostya)
        * Fixed "Unknown key in access token json: id_token" error in OAuth2 client (See #4437)
        * Fixed macro lookup conflicting with method lookup when including on top level (See #236)
        * Fixed Vagrant images (see #4510, #4508, thanks @Val)
        DE

    announcement "Other",
      title: "How to implement to_json in Crystal lang",
      description: <<-DE
        This is an example of how to implement a generic to_json method in Crystal lang:

        * [https://snippets.aktagon.com/snippets/799-how-to-implement-to-json-in-crystal-lang](https://snippets.aktagon.com/snippets/799-how-to-implement-to-json-in-crystal-lang)
        DE
  end
end
