package MT::Plugin::WidgetSetCF;

use strict;
use base qw( MT::Plugin );
our $VERSION = '1.1'; 
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
                $html .= '<option value="" <mt:if name="field_value" eq=""> selected="selected"</mt:if>>None Selected</option>';
                MT::log("Version number: ".MT->version_number);
                if (MT->version_number < 4.2) { # For MT, pre-4.2, when the Widget Manager functionality was made core.
                    my $modulesets = MT::Plugin::WidgetManager::instance()->load_selected_modules($app->blog->id) || {};
                    my @names = sort keys %$modulesets;
                    foreach my $n (@names) {
                        $html .= '<option<mt:if name="field_value" eq="'.$n.'"> selected="selected"</mt:if>>'.$n.'</option>';
                    }
                }
                else { # For MT 4.2+.
                    use MT::Template;
                    my @widgetsets = MT::Template->load( {blog_id => $app->blog->id,
                                                          type    => 'widgetset',},
                                                         {sort      => 'name',
                                                          direction => 'ascend',},
                                                        );
                    foreach my $widgetset (@widgetsets) {
                        $html .= '<option<mt:if name="field_value" eq="' . $widgetset->name . '"> selected="selected"</mt:if>>' . $widgetset->name . '</option>';
                    }
                }
                $html .= '</select>';
                return $html;
            },
            no_default => 1,
            order => 500,
            column_def => 'vchar',
            },
        },
    });
}

sub _hdlr_WidgetSetExists {
    my ($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $set = $args->{'widgetset'};

    if (MT->version_number < 4.2) { # For MT, pre-4.2, when the Widget Manager functionality was made core.
        my $modulesets = MT::Plugin::WidgetManager::instance()->load_selected_modules($blog_id) || {};
        my @names = sort keys %$modulesets;
        foreach my $n (@names) {
            return 1 if $n eq $set;
        }
        return 0;
    }
    else { # For MT 4.2+.
        my $widgetset = MT::Template->load( {blog_id => $blog_id,
                                             type    => 'widgetset',
                                             name    => $set,});
        if ($widgetset->name eq $set) {
            return 1;
        }
        else {
            return 0;
        }
    }
}

1;
