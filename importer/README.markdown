Importer
========


## Setup

Importer is designed to run on Ruby 2.1.1 with Rails 4.0.4 and SQLite3.

The project includes a `.ruby-version` and `.ruby-gemset` file that are
intended for use with [RVM](https://rvm.io/). Once you have RVM installed
you can install Ruby 2.1.1 by running the command

```
  $ rvm install ruby 2.1.1
```

If you are working on OS X then SQLite3 should already be set up for
you. If not, there are installation instructions at [sqlite.org](https://sqlite.org/).

Once you have those dependencies taken care of, RVM will create an appropriate
gemset for you when you change into the /importer project directory. From there
run:

```
  $ bundle install
  $ rake db:create db:migrate
  $ RAILS_ENV=test rake db:create db:migrate
  $ rails s
```

This will start up a server at [localhost:3000](http://localhost:3000/)
that will run the application. You will be presented with the form to upload
a file.

If you wish to run the tests, from the /importer directory use

```
  $ rspec
```


## Design

For simplicity sake I use most of Rails' conventions, with one exception
for the test suite. Since I don't have any experience with MiniTest I
replaced it with Rspec.

As far as the data normalization goes, I chose to split the incoming
data into 4 models:

#### Purchasers

Identified by their name. I assumed that any two purchasers with the
same name were the same purchaser. This seems like a grave oversight
in our acquisition's data, since people can have the same name.


#### Merchants

Identified by their name and address. I asserted uniqueness on both
because it is possible for two different merchants to have the same
address (if they share an office building) or to have the same name
(by coincidence or if they are independently owned franchises).


#### Items

Identified by their description, price, and merchant. Once again, I
asserted uniqueness on all three of these attributes because there
are arguments where different items might share one or two of them.
For instance, a merchant may offer the same deal at a lower price to
first time customers or members but the description might remain the
same.


#### Transactions

Transactions connect Purchasers to Items along with the quantity of
items purchased. Every line in the parsed CSV amounts to one
transaction, so a purchaser could make duplicate purchases and they
would both be counted.


Most of the above models are just there for data representation. All
of the logic used to parse the CSV and then create the appropriate models
is in the CSVImporter class. Error handling is at a minimum under the
assumption that the CSV will always follow the same, complete format.
More robust handling could be added in but there's no need to solve a
problems that doesn't exist yet.
