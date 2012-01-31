// --
// jquery-combobox.js - special jquery ui combobox
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: jquery-combobox.js,v 1.4 2012-01-31 13:54:38 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

(function($) {
    $.widget("ui.combobox", {
        options: {
            Class: '',
            IDPrefixInput: 'Combo_',
            IDPrefixButton: 'ComboBtn_',
            ValidationTooltip: '',
            Lang: {
                ShowAllItems: 'Show all items'
            }
        },
        _create: function() {
            var Self = this,
                $Select = this.element.hide(),
                $Selected = $Select.children(":selected"),
                Value = $Selected.val() ? $Selected.text() : "",
                $Input = this.input = $("<input>")
                .addClass(this.options.Class)
                .attr('id', this.options.IDPrefixInput + $Select[0].id)
                .insertAfter($Select)
                .css('width', $Select.width())
                .val(Value)
                .autocomplete({
                    delay: 0,
                    minLength: 0,
                    source: function(Request, Response) {
                        var Matcher = new RegExp($.ui.autocomplete.escapeRegex(Request.term), "i" );

                        Response($Select.children("option").map(function() {
                            var Text = $(this).text();
                            if (this.value && (!Request.term || Matcher.test(Text)))
                                return {
                                    label: Text.replace(
                                        new RegExp(
                                            "(?![^&;]+;)(?!<[^<>]*)(" +
                                            $.ui.autocomplete.escapeRegex(Request.term) +
                                            ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                        ), "<strong>$1</strong>" ),
                                    value: Text,
                                    option: this
                                };
                        }));
                    },
                    select: function(Event, UI) {
                        if (UI.item.option.disabled) {
                            return false;
                        }
                        UI.item.option.selected = true;
                        Self._trigger("selected", Event, {
                            item: UI.item.option
                        });
                    },
                    open: function(Event, UI) {
                        $('ul.ui-autocomplete.ui-menu').each(function () {
                            var width = $(this).width();
                            $(this).width(width + 30);
                        });
                    },
                    change: function(Event, UI) {
                        if (!UI.item) {
                            var Matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
                                Valid = false;
                            $Select.children("option").each(function() {
                                if ($(this).text().match(Matcher)) {
                                    this.selected = Valid = true;
                                    return false;
                                }
                            });
                            if (!Valid) {
                                // remove invalid value, as it didn't match anything
                                $(this).val("");
                                $Select.val("");
                                $Input.data("autocomplete").term = "";
                                return false;
                            }
                        }
                    }
                })
                .addClass("ui-widget ui-widget-content ui-corner-left")
                .after(this.options.ValidationTooltip);

            $Input.data("autocomplete")._renderItem = function(UL, Item) {
                return $("<li></li>")
                    .data("item.autocomplete", Item)
                    .append("<a>" + Item.label + "</a>")
                    .appendTo(UL);
            };

            this.button = $("<button type='button'>&nbsp;</button>")
                .attr("tabIndex", -1)
                .attr("title", this.options.Lang.ShowAllItems)
                .attr('id', this.options.IDPrefixButton + $Select[0].id)
                .insertAfter($Input)
                .button({
                    icons: {
                        primary: "ui-icon-triangle-1-s"
                    },
                    text: false
                })
                .removeClass("ui-corner-all")
                .addClass("ui-corner-right ui-button-icon")
                .click(function(Event) {
                    // close if already visible
                    if ($Input.autocomplete("widget").is(":visible")) {
                        $Input.autocomplete("close");
                        return;
                    }

                    // pass empty string as value to search for, displaying all results
                    $Input.autocomplete("search", "").focus();
                    Event.preventDefault();
                    Event.stopPropagation();
                    return false;
                });
        },

        destroy: function() {
            this.input.remove();
            this.button.remove();
            this.element.show();
            $.Widget.prototype.destroy.call(this);
        }
    });
})(jQuery);