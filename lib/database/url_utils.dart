String fixImageUrl(String? url) {
  if (url == null || url.isEmpty) {
    return ''; // Если URL пустой или null, возвращаем пустую строку
  }
  if (url.startsWith('https:/') && !url.startsWith('https://')) {
    url = url.replaceFirst('https:/', 'https://');
  }
  url = url.replaceAll(' ', '%20');
  return url;
}
