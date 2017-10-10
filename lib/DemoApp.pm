package DemoApp;
use strict; use warnings; use Data::Dumper;

use Dancer2;
use Dancer2::Plugin::GraphQL;
use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar qw/ $String /;

set serializer => 'JSON';
set charset    => 'UTF-8';
set template   => 'simple';
set plugins => { 'GraphQL' => { graphiql => 1 } }; # equivalent of config file

my $fakedb = {
    "Africa" => { majorCity => "Lagos" },
    "Antarctica" => { majorCity => "McMurdo" },
    "Asia" => { majorCity => "Shanghai" },
    "Australasia" => { majorCity => "Sydney" },
    "Europe" => { majorCity => "London" },
    "North America" => { majorCity => "New York" },
    "South America" => { majorCity => "Brasilia" },
};

my $Continent = GraphQL::Type::Object->new(
    name => 'Continent',
    fields => {
        majorCity => {
            type => $String,
            resolve => sub {
                my ( $source ) = @_;
                return $source->{majorCity};
            },
        },
        qualities => {
            type => $String,
            resolve => sub { 'All great' },
        },
    },
);

my $schema = GraphQL::Schema->new(
    query => GraphQL::Type::Object->new(
        name => 'QueryRoot',
        fields => {
            continent => {
                type => $Continent,
                args => { name => { type => $String->non_null } },
                resolve => sub {
                    my ( $source, $args ) = @_;
                    return $source->{$args->{name}};
                },
            },
        },
    ),
);

get '/' => sub {
    send_as html => template 'index', {
        title => 'Perl GraphQL demo app',
    };
};

graphql '/graphql' => $schema, $fakedb;

1;
