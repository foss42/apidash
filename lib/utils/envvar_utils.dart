String getEnvironmentTitle(String? name) {
  if (name == null || name.trim() == "") {
    return "untitled";
  }
  return name;
}
