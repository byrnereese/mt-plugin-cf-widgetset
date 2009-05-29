package MT::Plugin::WidgetSetCF;

use strict;
use base qw( MT::Plugin );
our $VERSION = '1.0'; 
my $plugin = MT::Plugin::WidgetSetCF->new({
   id          => 'WidgetSetCF',
   key         => 'widget-set-cf',
   name        => 'Widget Set Custom Field',
   description => "Provides Movable Type with a new Custom Field type: a pull down menu listing all widget sets.",
   version     => $VERSION,
   author_name => "Byrne Reese",
   author_link => "http://www.majordojo.com/",
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
	tags => {
	    block => {
		'IfWidgetSetExists?' => \&_hdlr_WidgetSetExists,
	    },
	},
	customfield_types => {
	    widget_set => {
		label => 'Widget Set',
		field_html => sub {
		    my $app = MT->instance;
		    my $blog = $app->blog;

		    my $html = '<select name="<mt:var name="field_name">" id="<mt:var name="field_id">">';
		    my $modulesets = MT::Plugin::WidgetManager::instance()->load_selected_modules($app->blog->id) || {};
		    my @names = sort keys %$modulesets;
		    $html .= '<option value="" <mt:if name="field_value" eq=""> selected="selected"</mt:if>>None Selected</option>';
		    foreach my $n (@names) {
			$html .= '<option<mt:if name="field_value" eq="'.$n.'"> selected="selected"</mt:if>>'.$n.'</option>';
		    }
		    $html .= '</select>';
		    return $html;
		},
		field_html_params => sub {
		    my ($key, $tmpl_key, $tmpl_param) = @_;
		    my $app = MT->instance;
		    my $blog = $app->blog;
		},
	        no_default => 1,
	        order => 500,
                column_def => 'string(255)'
 	    },
	},
    });
}

sub _hdlr_WidgetSetExists {
    my ($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $set = $args->{'widgetset'};
    my $modulesets = MT::Plugin::WidgetManager::instance()->load_selected_modules($blog_id) || {};
    my @names = sort keys %$modulesets;
    foreach my $n (@names) {
	return 1 if $n eq $set;
    }
    return 0;
}
