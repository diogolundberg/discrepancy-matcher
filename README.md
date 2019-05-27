✔️ A simple discrepancy matcher

## Stack

Discrepancy Matcheris built using:

* [Bundler](https://bundler.io/), The best way to manage a Ruby application's gems.
* [Rspec](https://github.com/rspec/rspec), a behaviour driven development tool.
* [Sequel](https://github.com/jeremyevans/sequel), an database toolkit for Ruby.

## Requirements

The following software is required to be installed locally in order to get this project running:

* Ruby 2.6.3

## Run the project

1. Clone from github (this will create discrepancy-matcher in the current directory)
```
git clone https://github.com/diogolundberg/discrepancy-matcher
cd discrepancy-matcher
```

2. Run bundler
```
bundle
```

3. Set the REMOTE_URL environment variable
```
export REMOTE_URL=https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df
```

4. Try it!
```
ruby run.rb
```

## Run tests

```
rspec
```


## Premises and decisions

1- Create services with well defined responsabilities

    - FetchRemote know only about how to fetch data from the remote source
    - Match know only about how to find discrepancies

2- Services must be agnostic

    - It should not matter what type of storage is being used
    - It should not matter where the data is coming from

3- Dependency injection

    - FetchRemote will be injected in Match, in a way that anything could be in place as it is a Service.
