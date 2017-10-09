package DemoApp;
use strict; use warnings; use Data::Dumper;

use Dancer2;
use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar qw/ $String /;
use GraphQL::Execution;

my $schema = GraphQL::Schema->new(
    query => GraphQL::Type::Object->new(
        name => 'QueryRoot',
        fields => {
            continent => {
                type => $String,
                resolve => sub {
                    my ( undef, $args ) = @_;
                    return get_city( $args->{'continent'});
                },
            },
        },
    ),
);

get '/' => sub {
    template 'index', {
        title => 'Perl GraphQL demo app',
    };
};

my $JSON = JSON::MaybeXS->new->allow_nonref;

post '/graphql' => sub {
    return GraphQL::Execution->execute(
        $schema,
        request->body,
        undef,
        undef,
        undef,
        undef,
    );
};

sub get_city { return 'unimplemented' };

1; # return true

__END__
