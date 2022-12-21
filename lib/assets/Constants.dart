const String EMPTY_LIST = "No {} Data Available";
const String CACHE_KEY = "CACHE_KEY";
const int CACHE_TIME = 180;
const int TOTAL_ACCESSTOKEN_KEYS = 10;
const String DETA_DOMAIN_URL = "https://{}.deta.dev/";
const String DETA_LOGO = 'lib/assets/images/deta.png';

const List<String> REGIONS = ["Auto","Europe","US","Singapore","India","South America"];
Map REGION_CODE = {
  REGIONS[0]:"",
  REGIONS[1]:"eu-central-1",
  REGIONS[2]:"us-west-2",
  REGIONS[3]:"ap-southeast-1",
  REGIONS[4]:"ap-south-1",
  REGIONS[5]:"sa-east-1"
};

const List<String> STATUS_COUNTRY = ["Germany","India","Singapore","Brazil","US"];

const String HDR_SIGNATURE = "X-Deta-Signature";
const String HDR_TIMESTAMP = "X-Deta-Timestamp";
const String HDR_CONTENT_TYPE = "Content-Type";
const String HDR_CONTENT_TYPE_STR = "application/json";

const String USER_TXT = "Users";
const String ID_TXT = "ID";
const String DETAILS_TXT = "Details";
const String DESCRIPTION = "Description";
const String PROJECT_TXT = "Project";
const String KEYS_TXT = "Key";

const String CLIPBOARD_TXT = "{} : copied to Clipboard!";
//Titles
const String ALL_USER_TITLE = "All Users";
const String ADD_USER_TITLE = "Add User";
const String UPDATE_USER_TITLE = "Update User";
const String PROJECTS_TITLE = "Projects";
const String USER_ACCESS_TOKEN_TITLE = "User Access Tokens";
const String MICRO_TITLE = "Micros";
const String BASE_TITLE = "Bases";
const String DRIVE_TITLE = "Drive";
const String PROJECT_TOKEN_TITLE = "$PROJECT_TXT Key";
const String DOMAIN_TITLE = "Domains";
const String LOG_TITLE = "Logs";
const String INFO_TITLE = "Info";
const String SETTINGS_TITLE = "Settings";
const String APP_INFO_TITLE = "App ${INFO_TITLE}";
const String DEV_INFO_TITLE = "Developer ${INFO_TITLE}";
const String DEV_DONO_TITLE = "Donations";

//CardUSER_ACCESS_TOKEN_
const String CARD_OPEN = "Open";
const String CARD_EDIT = "Edit";
const String CARD_DELETE = "Delete";
const String CARD_CLOSE = "Close";
const String CARD_SAVE = "Save";

//Messages
const String UNAUTHORZIED = "Unauthorized";
const String ERROR = "Error";
const String WARNING = "Warning";
const String SAVED = "Saved";
const String UPDATED = "Updated";
const String DELETED = "Deleted";
const String EXISTS = "Exists";
const String NO_DOMAIN = "Add a Domain";
const String VERSION = "Version";
const String BUILD = "Build Number";
const String NEW_UPDATE = "New Update";
const String NO_UPDATE = "No Update Found";
const String CHANGELOGS_TXT = "Changelogs";

const String ACCESSTOKEN_NOT_FOUND = "Access Token can't be Empty";
const String ACCESSTOKEN_INCORRECT = "Check your access token";
const String ACCESSTOKEN_USER_NOT_FOUND = "User not found";
const String ACCESSTOKEN_LIMIT = "Limit on number of access keys reached";
const String ACCESSTOKEN_CREATED = "Access Token created successfully";
const String DELETE_WARNING_LOCAL = "Are you sure you want to delete {}, locally?";
const String DELETE_WARNING = "Are you sure you want to delete {}?";
const String CREATE_WARNING = "Do you want to create {}?";
const String LIMIT_WARNING = "You can create {} more {} only.";
const String PROJECT_WARNING = "You cannot delete your project later.";
const String EXISTS_WARNING = "'{}' already exists";
const String CHECK_WARNING = "Check the {}";
const String UPDATED_MSG = "Updated/Added: {}";
const String UPDATED_ERR = "Error Updating/Adding: {}";
const String DELETED_MSG = "Deleted Successfully";
const String DELETED_ERR = "Deletion Failed";
const String LAUNCH_ERR = "Failed to launch";
const String CREATE_SUCCESS = "{} created successfully";
const String CREATE_ERR = "Failed to create {}";

//buttons
const String BTN_OK = "OK";
const String BTN_SAVE = "Save";
const String BTN_CHECK = "Check";
const String BTN_CANCEL = "Cancel";
const String BTN_CLOSE = "Close";
const String BTN_YES = "Yes";
const String BTN_NO = "No";
const String BTN_OPEN = "Open";
const String BTN_ADD = "Add";
const String BTN_EDIT = "Edit";
const String BTN_DETAILS = "Details";
const String BTN_DOWNLOAD = "Download";
const String BTN_DELETE = "Delete";
const String BTN_QR = "QR";
const String BTN_COPY = "Copy";
const String BTN_CHANGELOGS = CHANGELOGS_TXT;
const String BTN_CHECK_UPD = "Check update";


//Strings
const String ACCESS_TOKEN_TXT = "Access Token";
const String SPACE_ID_TXT = "Space $ID_TXT";
const String DETA_NAME_TXT = "Deta Name";
const String ROLE_TXT = "Role";


const String PROJECT_DETAILS_TXT = "$PROJECT_TXT $DETAILS_TXT";
const String PROJECT_NAME_TXT = "$PROJECT_TXT Name";
const String PROJECT_ID_TXT = "$PROJECT_TXT $ID_TXT";
const String PROJECT_DESP_TXT = "$PROJECT_TXT $DESCRIPTION";
const String PROJECT_REGION_TXT = "$PROJECT_TXT Region";


const String USER_ACCESS_TOKEN_DETAILS_TXT = "User $ACCESS_TOKEN_TXT $DETAILS_TXT";
const String ACCESS_TOKEN_ID_TXT = "$ACCESS_TOKEN_TXT $ID_TXT";
const String ACCESS_TOKEN_STARTDATE_TXT = "Created On";
const String ACCESS_TOKEN_EXPDATE_TXT = "Expires On";
const String ACCESS_TOKEN_EXPIN_TXT = "Expires In";
const String ACCESS_TOKEN_STATUS_TXT = "Status";
const String ACCESS_TOKEN_ACTIVE_TXT = "Active";
const String ACCESS_TOKEN_EXP_TXT = "Expired";

const String PROJECT_KEYS_DETAILS_TXT = "$KEYS_TXT $DETAILS_TXT";
const String PROJECT_KEYS_ACCESS_LEVEL = "Access Level";
const String PROJECT_KEYS_DESP_TXT = "$KEYS_TXT $DESCRIPTION";
const String PROJECT_KEYS_ID_TXT = "$KEYS_TXT $ID_TXT";

const String DOMAIN_TXT = "Domain";
const String SUBDOMAIN_TXT = "Subdomain";
const String CUSTOM_DOMAIN_TXT = "Custom domain";
const String IP_ADD_TXT = "IP Address";

//info page
const String INFO_ALIAS = "Micro Name";
const String INFO_PROJECT_ID = "$PROJECT_TXT $ID_TXT";
const String INFO_ID = ID_TXT;
const String INFO_LIBV = "Deta lib Version";
const String INFO_ENV_VAR = "Env Vars";
const String INFO_LOG_LVL = "Visor";
const String INFO_HTTP_A = "HTTP Auth";
const String INFO_RUNTIME = "Runtime";
const String INFO_MEM = "Memory";
const String INFO_TIMEOUT = "Timeout";
const String INFO_DEPS = "Dependencies";
const String INFO_CRON = "Cron";
const String INFO_CREATED_ON = ACCESS_TOKEN_STARTDATE_TXT;
const String INFO_UPD_ON = "Updated On";
const String INFO_ACC_NUM = "Account No.";
const String INFO_REGION = PROJECT_REGION_TXT;
const String INFO_NULL = "Null";
const String VISOR_ON = "Enabled";
const String VISOR_OFF = "Disabled";

//Tooltips
const String TOOLTIP_ADD_USER = "Add User";
const String TOOLTIP_ADD_SUBDOMAIN = "Add Subdomain";
const String TOOLTIP_EDIT_SUBDOMAIN = "Edit Subdomain";
const String TOOLTIP_ADD_CUSDOMAIN = "Add Custom Domain";

//local Storage
const String KEYNAME_CURRENT_USERID = "current";
const String KEYNAME_THEME = "theme";
const String KEYNAME_PROJECT_DATA = "projects_{}";
const String USER_ACCESS_TOKEN_API_DATA = "access_keys_{}";

//settings
const String THEME_TXT = "Theme";
List<String> THEMES_NAME_ARR = ["Pink","Purple"];

//my APIs
const String MY_API_URL = "https://api-deta-apk.deta.dev";
const String LATEST_UPD_URI = "${MY_API_URL}/updates/latest";

//APIs
const String BASE_API_URL = "v1.deta.sh";

const String SPACE_API_URI = "/spaces/";
const String PROJECT_API_URI = "$SPACE_API_URI{}/projects";
const String USER_ACCESS_TOKEN_API_URI = "/access_keys/";
const String MICRO_URI = "$PROJECT_API_URI/{}/programs";
const String BASES_URI = "$PROJECT_API_URI/{}/bases";
const String PROJECT_KEYS_URI = "/projects/{}/keys";
const String MICRO_DETAIL_URI = "/programs/{}";
const String SUBDOMAIN_URI = "$MICRO_DETAIL_URI/alias";
const String CUSDOMAIN_URI = "$MICRO_DETAIL_URI/domains";

const String STATUS_MICRO = "https://status-{}.deta.dev/results/micro";
const String STATUS_BASE = "https://status-{}.deta.dev/results/base";
const String STATUS_DRIVE = "https://status-{}.deta.dev/results/drive";

//Boxes
const String BOX_USER = "users";
const String BOX_CACHE_TIME = "cacheTime";
const String BOX_PROJECTS = "projects";
const String BOX_ACCESS_TOKEN = "accessToken";
const String BOX_ACCESS_TOKEN_KEY = "accessTokenKey";
const String BOX_PROJECT_TOKEN_KEY = "Project_Keys";
const String BOX_UA_TOKEN_KEY = "UA_Keys";
const String BOX_MICRO = "micros";
const String BOX_BASES = "bases";
const String BOX_UPD_INFO = "updates";

const String REPO = "https://github.com/Swakshan/Deta-APK/releases";
const String ABOUT = "This is an Unofficial App to access your Deta Account";