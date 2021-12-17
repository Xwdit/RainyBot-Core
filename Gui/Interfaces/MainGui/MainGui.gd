extends Control


func _ready():
	$TabContainer.set_tab_title(0,"RainyBot控制台")


func _process(_delta):
	$Status.text = "协议后端:Mirai | %s | Bot ID:%s" % ["已连接" if BotAdapter.is_bot_connected() else "未连接", str(BotAdapter.get_bot_id())]
