#!perl
use warnings;
use strict;
use lib 'lib';
use Digest::MD5::File qw(file_md5_hex);
use Test::More;

unless ( $ENV{'AMAZON_S3_EXPENSIVE_TESTS'} ) {
    plan skip_all => 'Testing this module for real costs money.';
} else {
    plan tests => 25;
}

use_ok('Net::Amazon::S3');

use vars qw/$OWNER_ID $OWNER_DISPLAYNAME/;

my $aws_access_key_id     = $ENV{'AWS_ACCESS_KEY_ID'};
my $aws_secret_access_key = $ENV{'AWS_ACCESS_KEY_SECRET'};

my $s3 = Net::Amazon::S3->new(
    {   aws_access_key_id     => $aws_access_key_id,
        aws_secret_access_key => $aws_secret_access_key,
        retry                 => 1,
		use_virtual_host		=> 1,
    }
);

for my $location ( undef, 'EU' ) {

  # create a bucket
  # make sure it's a valid hostname for EU testing
    my $bucketname = 'net-amazon-s3-test-' . lc($aws_access_key_id) . '-' . time;

    # for testing
    # my $bucket = $s3->bucket($bucketname); $bucket->delete_bucket; exit;

    my $bucket_obj = $s3->add_bucket(
        {   bucket              => $bucketname,
            acl_short           => 'public-read',
            location_constraint => $location
        }
    ) or die $s3->err . ": " . $s3->errstr;

    # now play with the file methods
    open (my $readme, "<", "README.md");
    open (my $bigfile, ">", "README.big.md");
	{
		local $/;
		my $content = <$readme>;
		for (1..10) {
			print $bigfile $content;
		}
	}
	close $readme;
	close $bigfile;

    my $readme_md5  = file_md5_hex('README.big.md');
    my $readme_size = -s 'README.big.md';
    my $keyname = 'testing.txt3';

    $bucket_obj->add_key_filename(
        $keyname, 'README.big.md',
        {   content_type        => 'text/plain',
            'x-amz-meta-colour' => 'orangy',
        }
    );

    my $response = $bucket_obj->get_key($keyname);
    is( $response->{content_type}, 'text/plain' );
    like( $response->{value}, qr/Amazon Digital Services/ );
    is( $response->{etag},                $readme_md5 );
    is( $response->{'x-amz-meta-colour'}, 'orangy' );
    is( $response->{content_length},      $readme_size );

    unlink('t/README.big.md');
    $response = $bucket_obj->get_key_filename( $keyname, undef, 't/README.big.md' );

    is( $response->{content_type},        'text/plain' );
    is( $response->{value},               '' );
    is( $response->{etag},                $readme_md5 );
    is( file_md5_hex('t/README.big.md'),      $readme_md5 );
    is( $response->{'x-amz-meta-colour'}, 'orangy' );
    is( $response->{content_length},      $readme_size );
    $bucket_obj->delete_key($keyname);

    ok( $bucket_obj->delete_bucket() );

	unlink ('README.big.md');
}
