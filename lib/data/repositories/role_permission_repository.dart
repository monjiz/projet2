abstract class RolePermissionRepository {
  Future<void> createRole(Map<String, dynamic> role);
  Future<void> updateRole(Map<String, dynamic> role);
  Future<void> deleteRole(String roleId);
  Future<void> assignPermissions(String roleId, List<String> permissions);
  Future<void> assignRoleToUser(String userId, String roleId);
  Future<List<Map<String, dynamic>>> getAllRoles();
  Future<List<String>> getAllPermissions();
}