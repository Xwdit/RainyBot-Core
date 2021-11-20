extends CoreAPI


class_name Console


static func print_text(text):
	GuiManager.console_print_text(text)
	
	
static func print_error(text):
	GuiManager.console_print_error(text)
	
	
static func print_warning(text):
	GuiManager.console_print_warning(text)
	

static func print_success(text):
	GuiManager.console_print_warning(text)
