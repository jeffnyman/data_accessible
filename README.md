# DataAccessible

[![Gem Version](https://badge.fury.io/rb/data_accessible.svg)](http://badge.fury.io/rb/data_accessible)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeffnyman/data_accessible/blob/master/LICENSE.txt)

The goal of DataAccessible is to allow for an expressive mechanism for referencing data by making that data a "first class citizen" of the structure that it applies to.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'data_accessible'
```

And then include it in your bundle:

    $ bundle

You can also install DataAccessible just as you would any other gem:

    $ gem install data_accessible

## Usage

Consider a data source like this:

```yaml
numbers:
  integers:
    one: 1

letters:
  vowels: "a, e, i, o, u"
```

This would be a YAML file. DataAccessible lets you refer to the data in this file via how it is structured by turning the keys into referenceable elements. There are a couple of ways to handle all of this.

### DataAccessible Sources

You can create an DataAccessible class like this:

```ruby
TestData = DataAccessible.sources do |source|
  source.data_load "data/sample_data.yml"
end
```

Here you assign the result of calling the `sources` action and you can pass a block where you load or merge data sources.

You can check the data you have available by either of the following approaches:

```ruby
puts TestData.to_h
puts TestData.data_accessible
```

Given the data from the YAML file, you would end up with this:

```
{"numbers"=>{"integers"=>{"one"=>1}}, "letters"=>{"vowels"=>"a, e, i, o, u"}}
```

When you load data into your class like this, accessor methods are defined on the class and recursively through the loaded data for each key. In the example data shown, the keys are "numbers" and "letters". This means you can easily walk through your data:

```ruby
puts TestData.numbers
puts TestData.numbers.integers
puts TestData.numbers.integers.one
puts TestData.letters
puts TestData.letters.vowels
```

The result of this would be:

```
{"integers"=>{"one"=>1}}
{"one"=>1}
1
{"vowels"=>"a, e, i, o, u"}
a, e, i, o, u
```

### Data Loading

The `data_load` method loads data into your class, wiping out any previously loaded data. So you don't want to do multiple `data_load` statements. You have to provide a data source to the `data_load` call. A data source can be a string and that string should represent a file path to an existing YAML file to be loaded. An error will be throw if the file cannot be found.

```ruby
TestData.data_load('data/sample_data.yml')
```

Here you can specify any path that you want, relative to the working directory of the running script.

If you want to shorten that, you can use a symbol. This approach requires that `data` is your default directory. Here's an example:

```ruby
TestData.data_load(:sample_data)
```

The given symbol represents the name of a `.yml` file located in the `data` directory.

You can also load up a specific hash as opposed to a file:

```ruby
TestData.data_load({ :names => ['Flash', 'Green Arrow', 'Firestorm'] })
```

The data loading mechanism also accepts an optional second parameter representing the name of a specific key within the data source from which data should be loaded.

```ruby
TestData.data_load "data/sample_data.yml", "letters"
```

So here only the `letters` key and anything within it would be loaded from the `sample_data.yml` file.

### Data Referencing

As you saw above, you can use the `to_h` or `data_accessible` methods to have all of the data loaded in your class returned to you as a hash.

If you feel it reads better, you can also use `accessible_data` as the method call.

## Merging Data

Let's say you have another data source called `another_sample_data.yml` with this:

```yaml
numbers:
  integers:
    two: 2
```

You could now do something like this:

```ruby
TestData = DataAccessible.sources do |source|
  source.data_load "data/sample_data.yml"
  source.data_merge "data/another_sample_data.yml"
end
```

Given the data in those files, you would end up with this:

```
{"numbers"=>{"integers"=>{"one"=>1, "two"=>2}}, "letters"=>{"vowels"=>"a, e, i, o, u"}}
```

Now you could do something similar to the above with the merged data set:

```ruby
puts TestData.numbers
puts TestData.numbers.integers
puts TestData.numbers.integers.one
puts TestData.numbers.integers.two
puts TestData.letters
puts TestData.letters.vowels
```

You would end up with:

```
{"integers"=>{"one"=>1, "two"=>2}}
{"one"=>1, "two"=>2}
1
2
{"vowels"=>"a, e, i, o, u"}
a, e, i, o, u
```

So notice how the similar data got merged together (for "numbers") and you still end up with all data ("numbers" and "letters").

You can also merge specific data without referring to a file. For example:

```ruby
TestData = DataAccessible.sources do |source|
  source.data_load "data/sample_data.yml"
  source.data_merge "data/another_sample_data.yml"
  source.data_merge test: 'xyzzy'
end

puts TestData.test
```

Here you can reference the previous data as before but now you are also merging in a specific set of data and that last statement would show you:

```
xyzzy
```

So what you are seeing here is that the `data_merge` method is somewhat equivalent to `data_load` with the exception that the data source is _merged_. This means entries with duplicate keys are overwritten with previously loaded data. Also, you can pass a namespace to merge just as you did during loading:

```ruby
TestData.data_merge "data/sample_data.yml", "letters"
````

### DataAccessible Mixin

You can potentially make the above approach a bit easier to by having your class include `DataAccessible`, rather than calling `sources` directly. For example:

```ruby
class TestData
  include DataAccessible

  data_load "data/sample_data.yml"
  data_merge "data/another_sample_data.yml"
  data_merge test: 'xyzzy'
end

puts TestData.accessible_data
```

A key thing to note here is that the data is a first class citizen of the class, not of instances of the class. You can reference data from an object, however, by doing something like this:

```ruby
class TestData
  include DataAccessible

  data_load "data/sample_data.yml"
  data_merge "data/another_sample_data.yml"
  data_merge test: 'xyzzy'

  def action
    puts self.class.accessible_data
  end
end

data = TestData.new
data.action
```

## Getting and Setting Data

Consider the following:

```ruby
class TestData
  include DataAccessible
end

TestData.data_load({
  :superheroes => {
    :green_lantern => {
      :secret_identity => [
        { name: 'Hal Jordan' },
        { name: 'John Stewart '},
        { name: 'Guy Gardner' }
      ]
    }
  }
})
```

You can reference the data as such:

```ruby
puts TestData.superheroes.green_lantern.secret_identity[0].name
puts TestData.superheroes[:green_lantern].secret_identity[0].name
puts TestData.superheroes.green_lantern
```

That will get you:

```
Hal Jordan
Hal Jordan
{:secret_identity=>[{:name=>"Hal Jordan"}, {:name=>"Kyle Rayner"}, {:name=>"Guy Gardner"}]}
```

You can also set the data by referencing an index directly:

```ruby
TestData[:superheroes].green_lantern.secret_identity[1].name = 'Kyle Rayner'
```

What this is showing you is the reference via a `[]` method. This gets data from your class and will return `nil` if the key does not exist. That can make this method useful for assigning default values in the absence of a key, as such:

```ruby
villain = TestData[:supervillain] || 'Parallax'
```

You can also use a `[]=` method.

```ruby
TestData[:supervillain] = 'Parallax'
puts TestData.supervillain
```

### Caveat on Accessors

Consider the following:

```ruby
class TestData
  include DataAccessible
end

TestData.data_load({})

TestData[:hal_jordan] = "Green Lantern"  # []=
puts TestData[:hal_jordan]               # []
puts TestData.hal_jordan
```

You can see how the key is referenced. In both cases you will get a value of "Green Lantern" returned. The comments show you which methods on DataAccessible are being called. Notice that the "hal_jordan" key is being created on the fly. Now consider this:

```ruby
class TestData
  include DataAccessible
end

TestData.data_load({ hal_jordan: { :superhero => 'Green Lantern' } })
puts TestData.hal_jordan
puts TestData.hal_jordan.superhero

TestData.hal_jordan[:evil] = 'Parallax'
puts TestData.hal_jordan[:evil] # WORKS
puts TestData.hal_jordan.evil   # DOES NOT WORK
```

Notice the comments here. The reason the last statement does not work is because the when the `[:evil]` key and value is established above, this does not call `[]=` on DataAccessible but rather the standard mechanism for insertion into a hash provided by Ruby. This means the accessors that DataAccessible provides are not created. So this is where you would want to use `data_merge` to bring in data.

## ERB Processing

DataAccessible will process files with Embedded Ruby. For example, you could have a data source like this:

```yaml
numbers:
  integers:
    one: 1
    four: <%= 2 + 2 %>
```

This would be referenced by DataAccessible as such:

```
{"numbers"=>{"integers"=>{"one"=>1, "four"=>4}}}
```

Notice how the keyword "four" shows the calculated value.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec:all` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/data_accessible](https://github.com/jeffnyman/data_accessible). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another testing tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To contribute to DataAccessible:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## License

DataAccessible is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/data_accessible/blob/master/LICENSE.txt) file for details.
