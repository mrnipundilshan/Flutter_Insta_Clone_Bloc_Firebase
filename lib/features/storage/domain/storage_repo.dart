abstract class StorageRepo {
  // upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload profile images on web platforms
  Future<String?> uploadProfileImageWeb(String fileBytes, String fileName);
}
