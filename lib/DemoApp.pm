package DemoApp;
use strict; use warnings; use Data::Dumper;

use Dancer2;
use Dancer2::Plugin::Ajax;
use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar qw/ $String /;
use GraphQL::Execution;

my $schema = GraphQL::Schema->new(
    query => GraphQL::Type::Object->new(
        name => 'QueryRoot',
        fields => {
            city => {
                type => $String,
                resolve => sub {
                    my ( undef, $args ) = @_;
                    return get_coordinates( $args->{'city'});
                },
            },
        },
    ),
);

my $JSON = JSON::MaybeXS->new->allow_nonref;

get '/' => sub {
    template 'index', {
        title => 'Perl GraphQL demo app',
    };
};

ajax '/' => sub {
    my $json = $JSON->decode(request->body);
    return GraphQL::Execution->execute(
        $schema,
        $json->{'query'}->{'city'},
        undef,
        undef,
        undef,
        undef,
    );
};

sub get_coordinates { return 'unimplemented' };

1; # return true

__END__
