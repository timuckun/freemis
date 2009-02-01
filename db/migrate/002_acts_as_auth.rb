class ActsAsAuth < ActiveRecord::Migration
  def self.up
   User.create(
    :login=>"admin",
    :password=>"spacedog",
    :password_confirmation=>"spacedog",
    :firstname=>"The",
    :lastname=>"Admin",
    :title=>"Mr")
  Group.create(
    :name=>"teachers")
  Group.create(
    :name=>"admins")
  Group.create(
    :name=>"hods")
  Group.create(
    :name=>"guidance")
  Group.create(
    :name=>"Head Teacher")
  User.find_by_login("admin").groups<<Group.find_by_name("admins")
  Organization.create(
    :name=>"Your School",
    :email=>"you@yourschool.com")
    
    rename_column "users", "salted_password", "crypted_passwor" rescue nil
    remove_column "users", "role"
    remove_column "users", "teacher_department"
    remove_column "users", "teacher_code"
    remove_column "users", "token_expiry"
    remove_column "users", "delete_after"
    add_column "users", "created_at", :datetime rescue nil
    add_column "users", "updated_at", :datetime rescue nil
    execute "TRUNCATE TABLE `accesses`;"
execute "TRUNCATE TABLE `actions`;"

execute "INSERT INTO `actions` (`id`, `menu_text`, `menu_order`, `menu_action`, `controller`) VALUES (4, 'Ad Hoc', 4, 'adhoc', 'positives'),
(6, 'Log Out', 10, 'logout', 'account'),
(9, 'Remove Pupils', 2, 'remove', 'pupils'),
(10, 'Claim Sets', 9, 'user_claim', 'pupil_sets'),
(11, 'Edit My Details', 11, 'edit', 'account'),
(14, 'View', 0, 'absentview', 'absences'),
(17, 'year set up', 0, 'reports_global_setup', 'reports'),
(18, 'new', 0, 'new', 'courses'),
(20, 'New', 10, 'new', 'pupil_sets'),
(22, 'Set targets', 0, 'set_targets', 'tracking'),
(23, 'Write Full Reports', 10, 'write', 'reports'),
(24, 'Tracking Setup', 0, 'tracking_setup', 'tracking'),
(27, 'Print Letters', 0, 'print_letters', 'letters'),
(28, 'New Pupil', 3, 'new', 'pupils'),
(29, 'View Faculty Reports', 10, 'view_faculty_reports', 'reports'),
(31, 'Print Reports', 12, 'print_reports', 'reports'),
(33, 'Set Cutoffs', 2, 'set_cutoffs', 'merits'),
(34, 'Print Merits', 3, 'print_merits', 'merits'),
(35, 'List Reports', 0, 'list', 'reports'),
(36, 'Search', 0, 'search', 'pupils'),
(37, 'Print', 0, 'print', 'positives'),
(38, 'List My Sets', 0, 'user_list', 'pupil_sets'),
(39, 'Write Interim Report', 0, 'write_interims', 'reports'),
(40, 'Summarize Full Reports', 0, 'summarize', 'reports'),
(41, 'Unexplained Absences', 0, 'register', 'registration'),
(43, 'Print Letters', 0, 'print_letters', 'tracking'),
(44, 'Check Targets Set', 0, 'check_tracking_completion', 'tracking'),
(45, 'Print Full Reports', 0, 'print_full_collated_reports', 'reports'),
(50, 'Award Merits', 1, 'award', 'merits'),
(51, 'Print Interims', 5, 'print_interim', 'reports'),
(52, 'edit', 0, 'edit', 'courses'),
(53, 'Edit', 10, 'edit', 'pupil_sets'),
(54, 'Analyse Reports', 0, 'analysis', 'reports'),
(55, 'Change a User''s Password', 5, 'admin_change_password', 'user'),
(56, 'Edit User Details', 5, 'admin_edit', 'user'),
(57, 'Create New User', 1, 'signup', 'user');"

execute "INSERT INTO `accesses` (`action_id`, `group_id`) VALUES (4, 1),
(6, 1),
(10, 1),
(11, 1),
(22, 1),
(23, 1),
(36, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(50, 1),
(6, 2),
(14, 2),
(18, 2),
(20, 2),
(24, 2),
(27, 2),
(28, 2),
(33, 2),
(34, 2),
(36, 2),
(37, 2),
(43, 2),
(44, 2),
(45, 2),
(51, 2),
(52, 2),
(53, 2),
(54, 2),
(55, 2),
(56, 2),
(57, 2),
(29, 3);"

 
  end

  def self.down
    rename_column "users", "crypted_password", "salted_password"
    add_column "users", "role", :string
    add_column "users", "teacher_department", :string
    add_column "users", "teacher_code", :string
    add_column "users", "token_expiry", :datetime
    add_column "users", "delete_after", :datetime
    remove_column "users", "created_at"
    remove_column "users", "updated_at"
execute "TRUNCATE TABLE `accesses`;"
    execute "TRUNCATE TABLE `actions`;"
    execute "INSERT INTO `actions` (`id`, `menu_text`, `menu_order`, `menu_action`, `controller`) VALUES 
 (4, 'Ad Hoc', 4, 'adhoc', 'positives'),
 (6, 'Log Out', 10, 'logout', 'user'),
 (9, 'Remove Pupils', 2, 'remove', 'pupils'),
 (10, 'Claim Sets', 9, 'user_claim', 'pupil_sets'),
 (11, 'Change Password', 11, 'change_password', 'user'),
 (14, 'View', 0, 'absentview', 'absences'),
 (17, 'year set up', 0, 'reports_global_setup', 'reports'),
 (18, 'new', 0, 'new', 'courses'),
 (19, 'Add User', 5, 'signup', 'user'),
 (20, 'New', 10, 'new', 'pupil_sets'),
 (22, 'Set targets', 0, 'set_targets', 'tracking'),
 (23, 'Write Full Reports', 10, 'write', 'reports'),
 (24, 'Tracking Setup', 0, 'tracking_setup', 'tracking'),
 (25, 'Edit Users', 6, 'user_setup', 'users'),
 (27, 'Print Letters', 0, 'print_letters', 'letters'),
 (28, 'New Pupil', 3, 'new', 'pupils'),
 (29, 'View Faculty Reports', 10, 'view_faculty_reports', 'reports'),
 (31, 'Print Reports', 12, 'print_reports', 'reports'),
 (33, 'Set Cutoffs', 2, 'set_cutoffs', 'merits'),
 (34, 'Print Merits', 3, 'print_merits', 'merits'),
 (35, 'List Reports', 0, 'list', 'reports'),
 (36, 'Search', 0, 'search', 'pupils'),
 (37, 'Print', 0, 'print', 'positives'),
 (38, 'List My Sets', 0, 'user_list', 'pupil_sets'),
 (39, 'Write Interim Report', 0, 'write_interims', 'reports'),
 (40, 'Summarize Full Reports', 0, 'summarize', 'reports'),
 (41, 'Unexplained Absences', 0, 'register', 'registration'),
 (42, 'Allocate Groups', 1, 'allocate_groups', 'user'),
 (43, 'Print Letters', 0, 'print_letters', 'tracking'),
 (44, 'Check Targets Set', 0, 'check_tracking_completion', 'tracking'),
 (45, 'Print Full Reports', 0, 'print_full_collated_reports', 'reports'),
 (50, 'Award Merits', 1, 'award', 'merits'),
 (51, 'Print Interims', 5, 'print_interim', 'reports'),
 (52, 'edit', 0, 'edit', 'courses'),
 (53, 'Edit', 10, 'edit', 'pupil_sets'),
 (54, 'Analyse Reports', 0, 'analysis', 'reports'),
 (55, 'Admin Edit', 4, 'admin_edit', 'user');"

execute "INSERT INTO `accesses` (`action_id`, `group_id`)  VALUES 
  (6, 1),
  (10, 1),
  (11, 1),
  (22, 1),
  (23, 1),
  (36, 1),
  (38, 1),
  (39, 1),
  (40, 1),
  (41, 1),
  (50, 1),
  (6, 2),
  (14, 2),
  (18, 2),
  (19, 2),
  (20, 2),
  (24, 2),
  (25, 2),
  (27, 2),
  (28, 2),
  (33, 2),
  (34, 2),
  (36, 2),
  (37, 2),
  (42, 2),
  (43, 2),
  (44, 2),
  (45, 2),
  (51, 2),
  (52, 2),
  (53, 2),
  (54, 2),
  (55, 2),
  (29, 3);"
  end
end
