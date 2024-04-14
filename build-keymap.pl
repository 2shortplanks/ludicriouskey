#!/usr/bin/perl

use 5.30.0;
use warnings;
use experimental qw(signatures);
use JSON::PP qw(encode_json);

# these keys are taken from
# https://github.com/pqrs-org/Karabiner-Elements/blob/f164989279f4b17864b78583abaff96ead26c60c/src/share/types/momentary_switch_event_details/key_code.hpp

# these are the standard keys that are on a mac laptop US-english keyboard
# that the user might want to press in combination with the caps lock key
my @standard_keys = <<'STANDARD_KEYS' =~ m/[{]"([^"]+)"/g;
    {"a", pqrs::hid::usage::keyboard_or_keypad::keyboard_a},
    {"b", pqrs::hid::usage::keyboard_or_keypad::keyboard_b},
    {"c", pqrs::hid::usage::keyboard_or_keypad::keyboard_c},
    {"d", pqrs::hid::usage::keyboard_or_keypad::keyboard_d},
    {"e", pqrs::hid::usage::keyboard_or_keypad::keyboard_e},
    {"f", pqrs::hid::usage::keyboard_or_keypad::keyboard_f},
    {"g", pqrs::hid::usage::keyboard_or_keypad::keyboard_g},
    {"h", pqrs::hid::usage::keyboard_or_keypad::keyboard_h},
    {"i", pqrs::hid::usage::keyboard_or_keypad::keyboard_i},
    {"j", pqrs::hid::usage::keyboard_or_keypad::keyboard_j},
    {"k", pqrs::hid::usage::keyboard_or_keypad::keyboard_k},
    {"l", pqrs::hid::usage::keyboard_or_keypad::keyboard_l},
    {"m", pqrs::hid::usage::keyboard_or_keypad::keyboard_m},
    {"n", pqrs::hid::usage::keyboard_or_keypad::keyboard_n},
    {"o", pqrs::hid::usage::keyboard_or_keypad::keyboard_o},
    {"p", pqrs::hid::usage::keyboard_or_keypad::keyboard_p},
    {"q", pqrs::hid::usage::keyboard_or_keypad::keyboard_q},
    {"r", pqrs::hid::usage::keyboard_or_keypad::keyboard_r},
    {"s", pqrs::hid::usage::keyboard_or_keypad::keyboard_s},
    {"t", pqrs::hid::usage::keyboard_or_keypad::keyboard_t},
    {"u", pqrs::hid::usage::keyboard_or_keypad::keyboard_u},
    {"v", pqrs::hid::usage::keyboard_or_keypad::keyboard_v},
    {"w", pqrs::hid::usage::keyboard_or_keypad::keyboard_w},
    {"x", pqrs::hid::usage::keyboard_or_keypad::keyboard_x},
    {"y", pqrs::hid::usage::keyboard_or_keypad::keyboard_y},
    {"z", pqrs::hid::usage::keyboard_or_keypad::keyboard_z},
    {"1", pqrs::hid::usage::keyboard_or_keypad::keyboard_1},
    {"2", pqrs::hid::usage::keyboard_or_keypad::keyboard_2},
    {"3", pqrs::hid::usage::keyboard_or_keypad::keyboard_3},
    {"4", pqrs::hid::usage::keyboard_or_keypad::keyboard_4},
    {"5", pqrs::hid::usage::keyboard_or_keypad::keyboard_5},
    {"6", pqrs::hid::usage::keyboard_or_keypad::keyboard_6},
    {"7", pqrs::hid::usage::keyboard_or_keypad::keyboard_7},
    {"8", pqrs::hid::usage::keyboard_or_keypad::keyboard_8},
    {"9", pqrs::hid::usage::keyboard_or_keypad::keyboard_9},
    {"0", pqrs::hid::usage::keyboard_or_keypad::keyboard_0},
    {"return_or_enter", pqrs::hid::usage::keyboard_or_keypad::keyboard_return_or_enter},
    {"escape", pqrs::hid::usage::keyboard_or_keypad::keyboard_escape},
    {"delete_or_backspace", pqrs::hid::usage::keyboard_or_keypad::keyboard_delete_or_backspace},
    {"tab", pqrs::hid::usage::keyboard_or_keypad::keyboard_tab},
    {"spacebar", pqrs::hid::usage::keyboard_or_keypad::keyboard_spacebar},
    {"hyphen", pqrs::hid::usage::keyboard_or_keypad::keyboard_hyphen},
    {"equal_sign", pqrs::hid::usage::keyboard_or_keypad::keyboard_equal_sign},
    {"open_bracket", pqrs::hid::usage::keyboard_or_keypad::keyboard_open_bracket},
    {"close_bracket", pqrs::hid::usage::keyboard_or_keypad::keyboard_close_bracket},
    {"backslash", pqrs::hid::usage::keyboard_or_keypad::keyboard_backslash},
    {"non_us_pound", pqrs::hid::usage::keyboard_or_keypad::keyboard_non_us_pound},
    {"semicolon", pqrs::hid::usage::keyboard_or_keypad::keyboard_semicolon},
    {"quote", pqrs::hid::usage::keyboard_or_keypad::keyboard_quote},
    {"grave_accent_and_tilde", pqrs::hid::usage::keyboard_or_keypad::keyboard_grave_accent_and_tilde},
    {"comma", pqrs::hid::usage::keyboard_or_keypad::keyboard_comma},
    {"period", pqrs::hid::usage::keyboard_or_keypad::keyboard_period},
    {"slash", pqrs::hid::usage::keyboard_or_keypad::keyboard_slash},
STANDARD_KEYS

# these are the function keys that are on a mac laptop US-english keyboard
my @function_keys = <<'FUNCTION_KEYS' =~ m/[{]"([^"]+)"/g;
    {"f1", pqrs::hid::usage::keyboard_or_keypad::keyboard_f1},
    {"f2", pqrs::hid::usage::keyboard_or_keypad::keyboard_f2},
    {"f3", pqrs::hid::usage::keyboard_or_keypad::keyboard_f3},
    {"f4", pqrs::hid::usage::keyboard_or_keypad::keyboard_f4},
    {"f5", pqrs::hid::usage::keyboard_or_keypad::keyboard_f5},
    {"f6", pqrs::hid::usage::keyboard_or_keypad::keyboard_f6},
    {"f7", pqrs::hid::usage::keyboard_or_keypad::keyboard_f7},
    {"f8", pqrs::hid::usage::keyboard_or_keypad::keyboard_f8},
    {"f9", pqrs::hid::usage::keyboard_or_keypad::keyboard_f9},
    {"f10", pqrs::hid::usage::keyboard_or_keypad::keyboard_f10},
    {"f11", pqrs::hid::usage::keyboard_or_keypad::keyboard_f11},
    {"f12", pqrs::hid::usage::keyboard_or_keypad::keyboard_f12},
FUNCTION_KEYS

# these are the keys that are on.
# note that we do not include num-lock
my @keypad_keys = <<'KEYPAD_KEYS' =~ m/[{]"([^"]+)"/g;
    {"keypad_slash", pqrs::hid::usage::keyboard_or_keypad::keypad_slash},
    {"keypad_asterisk", pqrs::hid::usage::keyboard_or_keypad::keypad_asterisk},
    {"keypad_hyphen", pqrs::hid::usage::keyboard_or_keypad::keypad_hyphen},
    {"keypad_plus", pqrs::hid::usage::keyboard_or_keypad::keypad_plus},
    {"keypad_enter", pqrs::hid::usage::keyboard_or_keypad::keypad_enter},
    {"keypad_1", pqrs::hid::usage::keyboard_or_keypad::keypad_1},
    {"keypad_2", pqrs::hid::usage::keyboard_or_keypad::keypad_2},
    {"keypad_3", pqrs::hid::usage::keyboard_or_keypad::keypad_3},
    {"keypad_4", pqrs::hid::usage::keyboard_or_keypad::keypad_4},
    {"keypad_5", pqrs::hid::usage::keyboard_or_keypad::keypad_5},
    {"keypad_6", pqrs::hid::usage::keyboard_or_keypad::keypad_6},
    {"keypad_7", pqrs::hid::usage::keyboard_or_keypad::keypad_7},
    {"keypad_8", pqrs::hid::usage::keyboard_or_keypad::keypad_8},
    {"keypad_9", pqrs::hid::usage::keyboard_or_keypad::keypad_9},
    {"keypad_0", pqrs::hid::usage::keyboard_or_keypad::keypad_0},
    {"keypad_period", pqrs::hid::usage::keyboard_or_keypad::keypad_period},
    ... a bunch of non numeric keypad keys are ommitted here from the source file...
    {"keypad_equal_sign", pqrs::hid::usage::keyboard_or_keypad::keypad_equal_sign},
KEYPAD_KEYS

my @high_function_keys = <<'HIGH_FUNCTION_KEYS' =~ m/[{]"([^"]+)"/g;
    {"f13", pqrs::hid::usage::keyboard_or_keypad::keyboard_f13},
    {"f14", pqrs::hid::usage::keyboard_or_keypad::keyboard_f14},
    {"f15", pqrs::hid::usage::keyboard_or_keypad::keyboard_f15},
    {"f16", pqrs::hid::usage::keyboard_or_keypad::keyboard_f16},
    {"f17", pqrs::hid::usage::keyboard_or_keypad::keyboard_f17},
    {"f18", pqrs::hid::usage::keyboard_or_keypad::keyboard_f18},
    {"f19", pqrs::hid::usage::keyboard_or_keypad::keyboard_f19},
    {"f20", pqrs::hid::usage::keyboard_or_keypad::keyboard_f20},
    {"f21", pqrs::hid::usage::keyboard_or_keypad::keyboard_f21},
    {"f22", pqrs::hid::usage::keyboard_or_keypad::keyboard_f22},
    {"f23", pqrs::hid::usage::keyboard_or_keypad::keyboard_f23},
    {"f24", pqrs::hid::usage::keyboard_or_keypad::keyboard_f24},
HIGH_FUNCTION_KEYS

my @modifier_keys = <<'MODIFIER_KEYS' =~ m/[{]"([^"]+)"/g;
    {"left_control", pqrs::hid::usage::keyboard_or_keypad::keyboard_left_control},
    {"left_shift", pqrs::hid::usage::keyboard_or_keypad::keyboard_left_shift},
    {"left_alt", pqrs::hid::usage::keyboard_or_keypad::keyboard_left_alt},
    {"left_gui", pqrs::hid::usage::keyboard_or_keypad::keyboard_left_gui},
MODIFIER_KEYS

my @rules;

#####
# hyper key (caps lock + a key, no other modifier keys!)
#####

my $hyper = {
    description => "Ludicrous Key's Hyper Key: Change CapsLock+key (without any other modifier key behin pressed) into Shift+Option+Control+Command+key",
    manipulators =>  [
        {
            type => "basic",
            from => {
                key_code => "caps_lock",
                modifiers => { optional => ["any"] },
            },
            to => [
               {
                    set_variable => {
                        name => "ludicrous_key_caps_lock_down",
                        value => 1,
                        key_up_value =>  0,
                    },
                },
            ],
        },
    ],
};
push @rules, $hyper;

my @with_caps_lock = (
    conditions => [
        {
            type => "variable_if",
            name => "ludicrous_key_caps_lock_down",
            value => 1
        }
    ],
);

for my $key (@standard_keys) {
    push $hyper->{manipulators}->@*, {
        type => "basic",
        from => {
            key_code => $key,
            modifiers => {},
        },
        to => [
            {
                key_code => $key,
                modifiers => [
                        "left_shift",
                        "left_command",
                        "left_control",
                        "left_option",
                ]
            }
        ],
        @with_caps_lock,
    };
}


#####
# 
#####

# key we're going to map to
my @pool;
for my $key (@high_function_keys) {
    for my $thingy (0..(2**@modifier_keys-1)) {
        my @m;
        for (0..(@modifier_keys-1)) {
            push @m, $modifier_keys[$_] if $thingy & (1<<$_);
        }
        push @pool, [{
            key_code => $key,
            modifiers => \@m,
        }]
    }
}

####
# finaally, print out the rules
####

print encode_json({
    title => "Ludicrous Key (http://www.ludicriouskey.com)",
    author => "Mark Fowler (http://ww.ludicriouskey.com)",
    rules => \@rules
});
