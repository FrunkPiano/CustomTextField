flutter自带的输入框，再添加字数限制后，使用系统输入法输入中文时，由于拼音的字母会实时计入字数限制判断中，导致最后的几个字无法完整输入。

![1603264418370615](/Users/mac/Downloads/1603264418370615.gif)

iOS原生的UITextField中提供了

```objective-c
[textField markedTextRange]
```

这一方法来识别中文的拼音，但是在flutter的输入框中并没有类似的方法。

所以只能使用原生输入框代替，安卓端继续使用flutter，整合成该插件进行使用。