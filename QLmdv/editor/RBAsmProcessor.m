
#import "RBAsmProcessor.h"
#import "RBTextSettings.h"

@interface RBAsmProcessor()

@property (strong, nonatomic) NSArray* biosCalls;

@end

@implementation RBAsmProcessor

- (id)init {
	self = [super init];

	self.keywords = [NSArray arrayWithObjects:
        // Mnemonics
        @"ORG",@"CODE",@"FCB",@"FCC",@"BSS",@"DB",@"DW",
        @"LDA",@"LDB",@"LDD",@"LDS",@"LDU",@"LDX",@"LDY",
        @"STA",@"STB",@"STD",@"STS",@"STU",@"STX",@"STY",
        @"INCA",@"INCB",@"INCD",@"INCS",@"INCU",@"INCX",@"INCY",
        @"DECA",@"DECB",@"DECD",@"DECS",@"DECU",@"DECX",@"DECY",
        @"EQU",@"TFR",@"RTS", @"FDB",
        @"BCC",@"BCS",@"BEQ",@"BGE",@"BGT",@"BHI",@"BHS",@"BLE",@"BLO",@"BLS",@"BLT",@"BMI",@"BNE",@"BPL",@"BRA",@"BRN",@"BSR",@"BVC",@"BVS",@"JMP",@"JSR",
        @"INCLUDE",
        nil];

        // Bios
    self.biosCalls = [NSArray arrayWithObjects:
        @"Vec_Snd_Shadow",@"Vec_Btn_State",@"Vec_Prev_Btns",@"Vec_Buttons",@"Vec_Button_1_1",@"Vec_Button_1_2",@"Vec_Button_1_3",@"Vec_Button_1_4",
        @"Vec_Button_2_1",@"Vec_Button_2_2",@"Vec_Button_2_3",@"Vec_Button_2_4",@"Vec_Joy_Resltn",@"Vec_Joy_1_X",@"Vec_Joy_1_Y",@"Vec_Joy_2_X",@"Vec_Joy_2_Y",
        @"Vec_Joy_Mux",@"Vec_Joy_Mux_1_X",@"Vec_Joy_Mux_1_Y",@"Vec_Joy_Mux_2_X",@"Vec_Joy_Mux_2_Y",@"Vec_Misc_Count",@"Vec_0Ref_Enable",@"Vec_Loop_Count",
        @"Vec_Brightness",@"Vec_Dot_Dwell",@"Vec_Pattern",@"Vec_Text_HW",@"Vec_Text_Height",@"Vec_Text_Width",@"Vec_Str_Ptr",@"Vec_Counters",@"Vec_Counter_1",@"Vec_Counter_2"
        @"Vec_Counter_3",@"Vec_Counter_4",@"Vec_Counter_5",@"Vec_Counter_6",@"Vec_RiseRun_Tmp",@"Vec_Angle", @"Vec_Run_Index",@"Vec_Rise_Index",@"Vec_RiseRun_Len",
        @"Vec_Rfrsh",@"Vec_Rfrsh_lo",@"Vec_Rfrsh_hi",@"Vec_Music_Work",@"Vec_Music_Wk_A",@"Vec_Music_Wk_7",@"Vec_Music_Wk_6",@"Vec_Music_Wk_5",@"Vec_Music_Wk_1",@"Vec_Freq_Table",
        @"Vec_Max_Players",@"Vec_Max_Games",@"Vec_ADSR_Table",@"Vec_Twang_Table",@"Vec_Music_Ptr",@"Vec_Expl_ChanA",@"Vec_Expl_Chans",@"Vec_Music_Chan",@"Vec_Music_Flag",
        @"Vec_Duration",@"Vec_Music_Twang",@"Vec_Expl_1",@"Vec_Expl_2",@"Vec_Expl_3",@"Vec_Expl_4",@"Vec_Expl_Chan",@"Vec_Expl_ChanB",@"Vec_ADSR_Timers",
        @"Vec_Music_Freq",@"Vec_Expl_Flag",@"Vec_Expl_Timer",@"Vec_Num_Players",@"Vec_Num_Game",@"Vec_Seed_Ptr",@"Vec_Random_Seed",@"Vec_Default_Stk",
        @"Vec_High_Score",@"Vec_SWI3_Vector",@"Vec_SWI2_Vector",@"Vec_FIRQ_Vector",@"Vec_IRQ_Vector",@"Vec_SWI_Vector",@"Vec_NMI_Vector",@"Vec_Cold_Flag",
        @"VIA_port_b",@"VIA_port_a",@"VIA_DDR_b",@"VIA_DDR_a",@"VIA_t1_cnt_lo",@"VIA_t1_cnt_hi",@"VIA_t1_lch_lo",@"VIA_t1_lch_hi",@"VIA_t2_lo",@"VIA_t2_hi",
        @"VIA_shift_reg",@"VIA_aux_cntl",@"VIA_cntl ",@"VIA_int_flags",@"VIA_int_enable",@"VIA_port_a_nohs",@"Cold_Start",@"Warm_Start",@"Init_VIA ",@"Init_OS_RAM",@"Init_OS",
        @"Wait_Recal",@"Set_Refresh",@"DP_to_D0",@"DP_to_C8",@"Read_Btns_Mask",@"Read_Btns",@"Joy_Analog",@"Joy_Digital",@"Sound_Byte",@"Sound_Byte_x",@"Sound_Byte_raw",@"Clear_Sound",
        @"Sound_Bytes",@"Sound_Bytes_x",@"Do_Sound ",@"Do_Sound_x",@"Intensity_1F",@"Intensity_3F",@"Intensity_5F",@"Intensity_7F",@"Intensity_a",
        @"Dot_ix_b",@"Dot_ix",@"Dot_d",@"Dot_here",@"Dot_List",@"Recalibrate",@"Moveto_x_7F",@"Moveto_d_7F",@"Moveto_ix_FF",@"Moveto_ix_7F",@"Moveto_ix_b",
        @"Moveto_ix",@"Moveto_d",@"Reset0Ref_D0",@"Check0Ref",@"Reset0Ref",@"Reset_Pen",@"Reset0Int",@"Print_Str_hwyx",@"Print_Str_yx", @"Print_Str_d",
        @"Print_List_hw",@"Print_List",@"Print_List_chk",@"Print_Ships_x",@"Print_Ships",@"Mov_Draw_VLc_a",@"Mov_Draw_VL_b",@"Mov_Draw_VLcs",@"Mov_Draw_VL_ab",@"Mov_Draw_VL_a",
        @"Mov_Draw_VL",@"Mov_Draw_VL_d",@"Draw_VLc",@"Draw_VL_b",@"Draw_VLcs",@"Draw_VL_ab",@"Draw_VL_a",@"Draw_VL",@"Draw_Line_d",@"Draw_VLp_FF",@"Draw_VLp_7F",
        @"Draw_VLp_scale",@"Draw_VLp_b",@"Draw_VLp",@"Draw_Pat_VL_a",@"Draw_Pat_VL",@"Draw_Pat_VL_d",@"Draw_VL_mode",@"Print_Str",@"Random_3",@"Random",
        @"Init_Music_Buf",@"Clear_x_b",@"Clear_C8_RAM",@"Clear_x_256",@"Clear_x_d",@"Clear_x_b_80",@"Clear_x_b_a",@"Dec_3_Counters",@"Dec_6_Counters",@"Dec_Counters",
        @"Delay_3",@"Delay_2",@"Delay_1",@"Delay_0",@"Delay_b",@"Delay_RTS",@"Bitmask_a",@"Abs_a_b",@"Abs_b",@"Rise_Run_Angle",@"Get_Rise_Idx",
        @"Get_Run_Idx",@"Get_Rise_Run",@"Rise_Run_X",@"Rise_Run_Y",@"Rise_Run_Len",@"Rot_VL_ab",@"Rot_VL",@"Rot_VL_Mode",@"Rot_VL_M_dft",@"Xform_Run_a",
        @"form_Run",@"Xform_Rise_a",@"Xform_Rise",@"Move_Mem_a_1",@"Move_Mem_a",@"Init_Music_chk",@"Init_Music",@"Init_Music_x",@"Select_Game",@"Clear_Score",
        @"Add_Score_a", @"Add_Score_d",@"Strip_Zeros",@"Compare_Score",@"New_High_Score",@"Obj_Will_Hit_u",@"Obj_Will_Hit",@"Obj_Hit",@"Explosion_Snd",@"Draw_Grid_VL",
        @"music1",@"music2",@"music3",@"music4",@"music5",@"music6",@"music7",@"music8",@"music9",@"musica",@"musicb",@"musicc",@"musicd",@"Char_Table",@"Char_Table_End",

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

		if (c1 == ';') {
			// single line comment
			for (i = 1; i < length; ++i) {
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
            else if ([self.biosCalls containsObject:identifier]) {
                [self colorText:[RBTextSettings shared].functionColor atRange:NSMakeRange(position, i) textStorage:textStorage];
            }
			else {
				if (i < length && [string characterAtIndex:position + i] == '(') {
					// function call
					[self colorText:[RBTextSettings shared].functionColor atRange:NSMakeRange(position, i) textStorage:textStorage];
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
