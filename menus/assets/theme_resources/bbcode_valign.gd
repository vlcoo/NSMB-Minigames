@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextBbcodeValign
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [valign y=2.0]hello[/valign] in text.
var bbcode := "valign"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.offset = Vector2.UP * char_fx.env.get("y", 1.0)
	return true
