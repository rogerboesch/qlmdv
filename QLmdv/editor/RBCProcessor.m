
#import "RBCProcessor.h"
#import "RBTextSettings.h"

@interface RBCProcessor ()

@property (strong, nonatomic) NSArray* biosCallsSupported;
@property (strong, nonatomic) NSArray* biosCallsNotSupported;
@property (strong, nonatomic) NSArray* biosVariables;
@property (strong, nonatomic) NSArray* functions;

@end

@implementation RBCProcessor

- (id)init {
	self = [super init];

	self.keywords = [NSArray arrayWithObjects:
                     @"asm", @"BOOL", @"break", @"case", @"char", @"const", @"continue", @"default", @"do", @"else",
                     @"enum", @"false", @"for", @"goto", @"if", @"inline", @"sizeof", @"static", @"struct", @"switch", @"true", @"typedef", @"void", @"while",
                     @"uint8_t", @"int8_t", @"uint16_t", @"int16_t", @"uint32_t", @"int32_t", @"int", @"long", @"return", @"short", @"signed", @"unsigned",
                     nil];

    self.functions = [NSArray arrayWithObjects:
                      // Pragma header flags
                      @"vx_title_pos", @"vx_title_size", @"vx_title", @"vx_music", @"vx_copyright",
                      
                      // Helper functions
                      @"abs", @"set_text_size", @"set_scale", @"music_set_flag", @"music_get_flag", @"print_str_c", @"random_seed",
                      @"zero_beam", @"wait_for_beam",
                      
                      // Helper functions music
                      @"play_music", @"stop_music", @"is_music_playing", @"play_sound", @"stop_sound", @"update_audio",

                      // Helper functions, controller
                      @"controller_enable_1_x", @"controller_enable_1_y", @"controller_enable_2_x", @"controller_enable_2_y", @"controller_disable_1_x",
                      @"controller_disable_1_y", @"controller_disable_2_x", @"controller_disable_2_y", @"controller_check_buttons", @"controller_buttons_pressed",
                      @"controller_buttons_held", @"controller_button_1_1_pressed", @"controller_button_1_2_pressed", @"controller_button_1_3_pressed",
                      @"controller_button_1_4_pressed", @"controller_button_2_1_pressed", @"controller_button_2_2_pressed", @"controller_button_2_3_pressed",
                      @"controller_button_2_4_pressed", @"controller_button_1_1_held", @"controller_button_1_2_held", @"controller_button_1_3_held",
                      @"controller_button_1_4_held", @"controller_button_2_1_held", @"controller_button_2_2_held", @"controller_button_2_3_held",
                      @"controller_button_2_4_held", @"controller_check_joysticks", @"controller_joystick_1_x", @"controller_joystick_1_y",
                      @"controller_joystick_2_x", @"controller_joystick_2_y", @"controller_joystick_1_leftChange", @"controller_joystick_1_rightChange",
                      @"controller_joystick_1_downChange", @"controller_joystick_1_upChange", @"controller_joystick_1_left", @"controller_joystick_1_right",
                      @"controller_joystick_1_down", @"controller_joystick_1_up", @"controller_joystick_2_left", @"controller_joystick_2_right",
                      @"controller_joystick_2_down", @"controller_joystick_2_up",
                      nil];

    self.biosVariables = [NSArray arrayWithObjects:
                          @"Vec_Snd_Shadow", @"Vec_Btn_State", @"Vec_Prev_Btns", @"Vec_Buttons", @"Vec_Button_1_1", @"Vec_Button_1_2", @"Vec_Button_1_3",
                          @"Vec_Button_1_4", @"Vec_Button_2_1", @"Vec_Button_2_2", @"Vec_Button_2_3", @"Vec_Button_2_4", @"Vec_Joy_Resltn", @"Vec_Joy_1_X",
                          @"Vec_Joy_1_Y", @"Vec_Joy_2_X", @"Vec_Joy_2_Y", @"Vec_Joy_Mux", @"Vec_Joy_Mux_1_X", @"Vec_Joy_Mux_1_Y", @"Vec_Joy_Mux_2_X",
                          @"Vec_Joy_Mux_2_Y", @"Vec_Misc_Count", @"Vec_0Ref_Enable", @"Vec_Loop_Count", @"Vec_Brightness", @"Vec_Dot_Dwell", @"Vec_Pattern",
                          @"Vec_Text_HW", @"Vec_Text_Height", @"Vec_Text_Width", @"Vec_Str_Ptr", @"Vec_Counters", @"Vec_Counter_1", @"Vec_Counter_2",
                          @"Vec_Counter_3", @"Vec_Counter_4", @"Vec_Counter_5", @"Vec_Counter_6", @"Vec_RiseRun_Tmp", @"Vec_Angle", @"Vec_Run_Index",
                          @"Vec_Rise_Index", @"Vec_RiseRun_Len", @"Vec_Rfrsh", @"Vec_Rfrsh_lo", @"Vec_Rfrsh_hi", @"Vec_Music_Work", @"Vec_Music_Wk_A",
                          @"Vec_Music_Wk_7", @"Vec_Music_Wk_6", @"Vec_Music_Wk_5", @"Vec_Music_Wk_1", @"Vec_Freq_Table", @"Vec_Max_Players", @"Vec_Max_Games",
                          @"Vec_ADSR_Table", @"Vec_Twang_Table", @"Vec_Music_Ptr", @"Vec_Expl_ChanA", @"Vec_Expl_Chans", @"Vec_Music_Chan", @"Vec_Music_Flag",
                          @"Vec_Duration", @"Vec_Music_Twang", @"Vec_Expl_1", @"Vec_Expl_2", @"Vec_Expl_3", @"Vec_Expl_4", @"Vec_Expl_Chan", @"Vec_Expl_ChanB",
                          @"Vec_ADSR_Timers", @"Vec_Music_Freq", @"Vec_Expl_Flag", @"Vec_Expl_Timer", @"Vec_Num_Players", @"Vec_Num_Game", @"Vec_Seed_Ptr",
                          @"Vec_Random_Seed", @"Vec_Default_Stk", @"Vec_High_Score", @"Vec_SWI3_Vector", @"Vec_SWI2_Vector", @"Vec_FIRQ_Vector",
                          @"Vec_IRQ_Vector", @"Vec_SWI_Vector", @"Vec_NMI_Vector", @"Vec_Cold_Flag",
                          @"VIA_port_b", @"VIA_port_a", @"VIA_DDR_b", @"VIA_DDR_a", @"VIA_t1_cnt_lo", @"VIA_t1_cnt_hi", @"VIA_t1_lch_lo", @"VIA_t1_lch_hi",
                          @"VIA_t2_lo", @"VIA_t2_hi", @"VIA_shift_reg", @"VIA_aux_cntl", @"VIA_cntl", @"VIA_int_flags", @"VIA_int_enable", @"VIA_port_a_nohs",
                          
                          // Constants
                          @"JOYSTICK_1", @"JOYSTICK_2", 
                          nil];
    
    self.biosCallsSupported = [NSArray arrayWithObjects:
                               @"clear_sound", @"cold_start", @"do_sound", @"dot_d", @"dot_list", @"draw_line_d", @"draw_pat_vl_a", @"draw_vl_a",
                               @"explosion_snd", @"init_music_chk", @"init_os_ram", @"init_os", @"init_via", @"intensity_a", @"joy_analog", @"joy_digital",
                               @"moveto_d", @"print_str_d", @"random", @"read_btns", @"reset0ref", @"rot_vl_ab", @"set_refresh", @"wait_recal", @"warm_start",
                               
                               // gcc macros
                               @"Cold_Start", @"Do_Sound", @"Dot_d", @"Dot_List", @"Draw_Line_d", @"Draw_Pat_VL_a", @"Draw_VL_a",
                               @"Init_Music_chk", @"Init_OS_RAM", @"Init_OS", @"Init_VIA", @"Intensity_a", @"Joy_Analog", @"Joy_Digital",
                               @"Moveto_d", @"Print_Str_d", @"Random", @"Read_Btns", @"Reset0Ref", @"Rot_VL_ab", @"Set_Refresh", @"Wait_Recal", @"Warm_Start",
                               nil];
    
    self.biosCallsNotSupported = [NSArray arrayWithObjects:
                                  @"abs_a_b", @"abs_b", @"add_score_a", @"add_score_d", @"bitmask_a", @"check0ref", @"clear_c8_ram", @"clear_score",
                                  @"clear_x_256", @"clear_x_b_80", @"clear_x_b_a", @"clear_x_b", @"clear_x_d", @"compare_score",
                                  @"dec_3_counters", @"dec_6_counters", @"dec_counters", @"delay_1", @"delay_2", @"delay_3", @"delay_b", @"delay_rts", @"do_sound_x",
                                  @"dot_here", @"dot_ix_b", @"dot_ix", @"dot_list_reset", @"dp_to_c8", @"dp_to_d0draw_grid_vl", @"draw_pat_vl_d", @"draw_pat_vl",
                                  @"draw_vl_ab", @"draw_vl_b", @"draw_vl_mode", @"draw_vl", @"draw_vlc(c)", @"draw_vlcs", @"draw_vlp_7f", @"draw_vlp_b",
                                  @"draw_vlp_ff", @"draw_vlp_scale", @"draw_vlp", @"get_rise_idx", @"get_rise_run", @"get_run_idx",
                                  @"init_music_buf", @"init_music_x", @"init_music", @"intensity_1f", @"intensity_3f", @"intensity_5f", @"intensity_7f",
                                  @"intensity", @"mov_draw_vl_a", @"mov_draw_vl_ab", @"mov_draw_vl_b", @"mov_draw_vl_d",
                                  @"mov_draw_vl", @"mov_draw_vlc_a", @"mov_draw_vlcs", @"move_mem_a_1", @"move_mem_a", @"moveto_d_7f", @"moveto_ix_7f",
                                  @"moveto_ix_b", @"moveto_ix_ff", @"moveto_ix", @"moveto_x_7f", @"new_high_score", @"obj_hit", @"obj_will_hit_u",
                                  @"obj_will_hit", @"print_list_chk", @"print_list_hw", @"print_list", @"print_ships_x", @"print_ships", @"print_str_hwyx",
                                  @"print_str_yx", @"print_str", @"random_3", @"random", @"read_btns_mask", @"read_btns", @"recalibrate", @"reset_pen",
                                  @"reset0int", @"reset0ref_d0", @"rise_run_angle", @"rise_run_len", @"rise_run_x", @"rise_run_y", @"rot_vl_dft", @"rot_vl_mode_a",
                                  @"rot_vl_mode", @"rot_vl", @"select_game", @"sound_byte_raw", @"sound_byte_x", @"sound_byte", @"sound_bytes_x", @"sound_bytes",
                                  @"strip_zeros", @"xform_rise_a", @"xform_rise", @"xform_run_a", @"xform_run",
                                  
                                  // gcc macros
                                  @"Abs_a_b", @"Abs_b", @"Add_Score_a", @"Add_Score_d", @"Bitmask_a", @"Check0Ref", @"Clear_C8_RAM", @"Clear_Score",
                                  @"Clear_Sound", @"Clear_x_256", @"Clear_x_b_80", @"Clear_x_b_a", @"Clear_x_b", @"Clear_x_d", @"Compare_Score",
                                  @"Dec_3_Counters", @"Dec_6_Counters", @"Dec_Counters", @"Delay_0", @"Delay_1", @"Delay_2", @"Delay_3", @"Delay_b",
                                  @"Delay_RTS", @"Do_Sound_x", @"Dot_here", @"Dot_ix_b", @"Dot_ix", @"Dot_List_Reset", @"DP_to_C8", @"DP_to_D0",
                                  @"Draw_Grid_VL", @"Draw_Pat_VL_d", @"Draw_Pat_VL", @"Draw_VL_ab", @"Draw_VL_b", @"Draw_VL_mode", @"Draw_VL",
                                  @"Draw_VLc", @"Draw_VLcs", @"Draw_VLp_7F", @"Draw_VLp_b", @"Draw_VLp_FF", @"Draw_VLp_scale", @"Draw_VLp",
                                  @"Explosion_Snd", @"Get_Rise_Idx", @"Get_Rise_Run", @"Get_Run_Idx", @"Init_Music_Buf", @"Init_Music_chk",
                                  @"Init_Music_x", @"Init_Music", @"Intensity_1F", @"Intensity_3F", @"Intensity_5F", @"Intensity_7F", @"Intensity",
                                  @"Mov_Draw_VL_a", @"Mov_Draw_VL_ab", @"Mov_Draw_VL_b", @"Mov_Draw_VL_d", @"Mov_Draw_VL", @"Mov_Draw_VLc_a",
                                  @"Mov_Draw_VLcs", @"Move_Mem_a_1", @"Move_Mem_a", @"Moveto_d_7F", @"Moveto_ix_7F", @"Moveto_ix_b", @"Moveto_ix_FF",
                                  @"Moveto_ix", @"Moveto_x_7F", @"New_High_Score", @"Obj_Hit", @"Obj_Will_Hit_u", @"Obj_Will_Hit", @"Print_List_chk",
                                  @"Print_List_hw", @"Print_List", @"Print_Ships_x", @"Print_Ships", @"Print_Str_hwyx", @"Print_Str_yx", @"Print_Str",
                                  @"Random_3", @"Read_Btns_Mask", @"Recalibrate", @"Reset_Pen", @"Reset0Int", @"Reset0Ref_D0", @"Rise_Run_Angle",
                                  @"Rise_Run_Len", @"Rise_Run_X", @"Rise_Run_Y", @"Rot_VL_dft", @"Rot_VL_Mode_a", @"Rot_VL_Mode", @"Rot_VL", @"Select_Game",
                                  @"Sound_Byte_raw", @"Sound_Byte_x", @"Sound_Byte", @"Sound_Bytes_x", @"Sound_Bytes", @"Strip_Zeros", @"Xform_Rise_a",
                                  @"Xform_Rise", @"Xform_Run_a", @"Xform_Run",
                                  nil];
	return self;
}

- (void)syntaxHighlightTextStorage:(NSTextStorage*)textStorage startingAt:(NSUInteger)position {
	NSString* string = [textStorage string];
	NSUInteger length = [string length] - position;

	// for quotes and multi-line comments that return to directives when they end
	bool returnToDirective = false;

	NSUInteger i;
	
	while (length > 0 && length < 0x80000000) {
		if (!returnToDirective && ![self addResumePoint:position]) {
			return;
		}
		
		unichar c1 = [string characterAtIndex:position];
		unichar c2 = (length > 1 ? [string characterAtIndex:position + 1] : 'x');

		if (c1 == '/' && c2 == '/') {
			// single line comment
			for (i = 2; i < length; ++i) {
				if ([string characterAtIndex:position + i] == '\n' && [string characterAtIndex:position + i - 1] != '\\') {
					break;
				}
			}

			[self colorText:[RBTextSettings shared].commentColor atRange:NSMakeRange(position, i) textStorage:textStorage];

			position += i;
			length -= i;
		}
		else if (c1 == '/' && c2 == '*') {
			// multi line comment
			for (i = 2; i < length; ++i) {
				if ([string characterAtIndex:position + i - 1] == '*' && [string characterAtIndex:position + i] == '/') {
					break;
				}
			}
			
			[self colorText:[RBTextSettings shared].commentColor atRange:NSMakeRange(position, MIN(i + 1, length)) textStorage:textStorage];

			position += i;
			length -= i;
		}
		else if (c1 == '"' || c1 == '\'') {
			// quote
			NSUInteger quoteLength = [self quoteLength:string range:NSMakeRange(position, length)];

			[self colorText:(c1 == '"' ? [RBTextSettings shared].quoteColor : [RBTextSettings shared].constantColor) atRange:NSMakeRange(position, quoteLength) textStorage:textStorage];

			position += quoteLength;
			length -= quoteLength;
		}
		else if (returnToDirective || c1 == '#') {
			// preprocessor directive
			returnToDirective = false;
			
			for (i = 0; i < length; ++i) {
				unichar ic1 = [string characterAtIndex:position + i];
				
				if (ic1 == '"' || ic1 == '\'') {
					// quote
					returnToDirective = true;
					break;
				}

				unichar ic2 = (i + 1 < length ? [string characterAtIndex:position + i + 1] : 'x');

				if (ic1 == '/' && ic2 == '/') {
					// single line comment
					break;
				}

				if (ic1 == '/' && ic2 == '*') {
					// multi line comment
					returnToDirective = true;
					break;
				}
				
				if (ic1 == '\n' && [string characterAtIndex:position + i - 1] != '\\') {
					// end of the directive
					break;
				}
			}
			
			[self colorText:[RBTextSettings shared].directiveColor atRange:NSMakeRange(position, i) textStorage:textStorage];

			position += i;
			length -= i;
		}
		else if ((c1 >= '0' && c1 <= '9') || (c1 == '.' && (c2 >= '0' && c2 <= '9'))) {
			// number
			for (i = 1; i < length; ++i) {
				unichar c = [string characterAtIndex:position + i];

				if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '.')) {
					break;
				}
			}
			
			[self colorText:[RBTextSettings shared].constantColor atRange:NSMakeRange(position, i) textStorage:textStorage];

			position += i;
			length -= i;
		}
		else if ((c1 >= 'a' && c1 <= 'z') || (c1 >= 'A' && c1 <= 'Z') || c1 == '_') {
			// identifier
			for (i = 1; i < length; ++i) {
				unichar c = [string characterAtIndex:position + i];

				if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_')) {
					break;
				}
			}
			
			NSString* identifier = [string substringWithRange:NSMakeRange(position, i)];

			if ([self.keywords containsObject:identifier]) {
				[self colorText:[RBTextSettings shared].keywordColor atRange:NSMakeRange(position, i) textStorage:textStorage];
			}
            else if ([self.biosCallsSupported containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].keyword2Color atRange:NSMakeRange(position, i) textStorage:textStorage];
            }
            else if ([self.biosCallsNotSupported containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].keyword3Color atRange:NSMakeRange(position, i) textStorage:textStorage];
            }
            else if ([self.functions containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].functionColor atRange:NSMakeRange(position, i) textStorage:textStorage];
            }
            else if ([self.biosVariables containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].constantColor atRange:NSMakeRange(position, i) textStorage:textStorage];
            }
			else {
				if (i < length && [string characterAtIndex:position + i] == '(') {
					// function call
					//[self colorText:[RBTextSettings shared].functionColor atRange:NSMakeRange(position, i) textStorage:textStorage];
				}
				else {
					// variable / type
					[self colorText:[RBTextSettings shared].identifierColor atRange:NSMakeRange(position, i) textStorage:textStorage];
				}
			}

			position += i;
			length -= i;
		}
		else {
			++position;
			--length;
		}
	}
}

@end

/**
  RBCProcessor.m
  roboText

  Created by Roger Boesch on 11.03.18.
  Copyright © 2018 Roger Boesch. All rights reserved.
*/

