## 知识点汇总
###总结项目中碰到的问题和解决方法
public static String getTemplatePath(String templateName) {
  String path = Thread.currentThread().getContextClassLoader().getResource("").getPath();
  String filePath = path + templateName;
  return filePath;
}
