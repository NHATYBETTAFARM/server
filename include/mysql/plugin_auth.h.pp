#include <mysql/plugin.h>
typedef char my_bool;
typedef void * MYSQL_PLUGIN;
#include <mysql/services.h>
#include <mysql/service_my_snprintf.h>
extern struct my_snprintf_service_st {
  size_t (*my_snprintf_type)(char*, size_t, const char*, ...);
  size_t (*my_vsnprintf_type)(char *, size_t, const char*, va_list);
} *my_snprintf_service;
size_t my_snprintf(char* to, size_t n, const char* fmt, ...);
size_t my_vsnprintf(char *to, size_t n, const char* fmt, va_list ap);
#include <mysql/service_thd_alloc.h>
struct st_mysql_lex_string
{
  char *str;
  size_t length;
};
typedef struct st_mysql_lex_string MYSQL_LEX_STRING;
extern struct thd_alloc_service_st {
  void *(*thd_alloc_func)(void*, unsigned int);
  void *(*thd_calloc_func)(void*, unsigned int);
  char *(*thd_strdup_func)(void*, const char *);
  char *(*thd_strmake_func)(void*, const char *, unsigned int);
  void *(*thd_memdup_func)(void*, const void*, unsigned int);
  MYSQL_LEX_STRING *(*thd_make_lex_string_func)(void*, MYSQL_LEX_STRING *,
                                        const char *, unsigned int, int);
} *thd_alloc_service;
void *thd_alloc(void* thd, unsigned int size);
void *thd_calloc(void* thd, unsigned int size);
char *thd_strdup(void* thd, const char *str);
char *thd_strmake(void* thd, const char *str, unsigned int size);
void *thd_memdup(void* thd, const void* str, unsigned int size);
MYSQL_LEX_STRING *thd_make_lex_string(void* thd, MYSQL_LEX_STRING *lex_str,
                                      const char *str, unsigned int size,
                                      int allocate_lex_string);
#include <mysql/service_thd_wait.h>
typedef enum _thd_wait_type_e {
  THD_WAIT_SLEEP= 1,
  THD_WAIT_DISKIO= 2,
  THD_WAIT_ROW_LOCK= 3,
  THD_WAIT_GLOBAL_LOCK= 4,
  THD_WAIT_META_DATA_LOCK= 5,
  THD_WAIT_TABLE_LOCK= 6,
  THD_WAIT_USER_LOCK= 7,
  THD_WAIT_BINLOG= 8,
  THD_WAIT_GROUP_COMMIT= 9,
  THD_WAIT_SYNC= 10,
  THD_WAIT_NET= 11,
  THD_WAIT_LAST= 12
} thd_wait_type;
extern struct thd_wait_service_st {
  void (*thd_wait_begin_func)(void*, int);
  void (*thd_wait_end_func)(void*);
} *thd_wait_service;
void thd_wait_begin(void* thd, int wait_type);
void thd_wait_end(void* thd);
#include <mysql/service_progress_report.h>
extern struct progress_report_service_st {
  void (*thd_progress_init_func)(void* thd, unsigned int max_stage);
  void (*thd_progress_report_func)(void* thd,
                                   unsigned long long progress,
                                   unsigned long long max_progress);
  void (*thd_progress_next_stage_func)(void* thd);
  void (*thd_progress_end_func)(void* thd);
  const char *(*set_thd_proc_info_func)(void*, const char *info,
                                        const char *func,
                                        const char *file,
                                        unsigned int line);
} *progress_report_service;
void thd_progress_init(void* thd, unsigned int max_stage);
void thd_progress_report(void* thd,
                         unsigned long long progress,
                         unsigned long long max_progress);
void thd_progress_next_stage(void* thd);
void thd_progress_end(void* thd);
const char *set_thd_proc_info(void*, const char * info, const char *func,
                              const char *file, unsigned int line);
#include <mysql/service_debug_sync.h>
extern void (*debug_sync_C_callback_ptr)(void*, const char *, size_t);
#include <mysql/service_kill_statement.h>
enum thd_kill_levels {
  THD_IS_NOT_KILLED=0,
  THD_ABORT_SOFTLY=50,
  THD_ABORT_ASAP=100,
};
extern struct kill_statement_service_st {
  enum thd_kill_levels (*thd_kill_level_func)(const void*);
} *thd_kill_statement_service;
enum thd_kill_levels thd_kill_level(const void*);
#include <mysql/service_thd_timezone.h>
#include "mysql_time.h"
typedef long my_time_t;
enum enum_mysql_timestamp_type
{
  MYSQL_TIMESTAMP_NONE= -2, MYSQL_TIMESTAMP_ERROR= -1,
  MYSQL_TIMESTAMP_DATE= 0, MYSQL_TIMESTAMP_DATETIME= 1, MYSQL_TIMESTAMP_TIME= 2
};
typedef struct st_mysql_time
{
  unsigned int year, month, day, hour, minute, second;
  unsigned long second_part;
  my_bool neg;
  enum enum_mysql_timestamp_type time_type;
} MYSQL_TIME;
extern struct thd_timezone_service_st {
  my_time_t (*thd_TIME_to_gmt_sec)(void* thd, const MYSQL_TIME *ltime, unsigned int *errcode);
  void (*thd_gmt_sec_to_TIME)(void* thd, MYSQL_TIME *ltime, my_time_t t);
} *thd_timezone_service;
my_time_t thd_TIME_to_gmt_sec(void* thd, const MYSQL_TIME *ltime, unsigned int *errcode);
void thd_gmt_sec_to_TIME(void* thd, MYSQL_TIME *ltime, my_time_t t);
#include <mysql/service_sha1.h>
extern struct my_sha1_service_st {
  void (*my_sha1_type)(unsigned char*, const char*, size_t);
  void (*my_sha1_multi_type)(unsigned char*, ...);
  size_t (*my_sha1_context_size_type)();
  void (*my_sha1_init_type)(void *);
  void (*my_sha1_input_type)(void *, const unsigned char *, size_t);
  void (*my_sha1_result_type)(void *, unsigned char *);
} *my_sha1_service;
void my_sha1(unsigned char*, const char*, size_t);
void my_sha1_multi(unsigned char*, ...);
size_t my_sha1_context_size();
void my_sha1_init(void *context);
void my_sha1_input(void *context, const unsigned char *buf, size_t len);
void my_sha1_result(void *context, unsigned char *digest);
#include <mysql/service_md5.h>
extern struct my_md5_service_st {
  void (*my_md5_type)(unsigned char*, const char*, size_t);
  void (*my_md5_multi_type)(unsigned char*, ...);
  size_t (*my_md5_context_size_type)();
  void (*my_md5_init_type)(void *);
  void (*my_md5_input_type)(void *, const unsigned char *, size_t);
  void (*my_md5_result_type)(void *, unsigned char *);
} *my_md5_service;
void my_md5(unsigned char*, const char*, size_t);
void my_md5_multi(unsigned char*, ...);
size_t my_md5_context_size();
void my_md5_init(void *context);
void my_md5_input(void *context, const unsigned char *buf, size_t len);
void my_md5_result(void *context, unsigned char *digest);
#include <mysql/service_logger.h>
typedef struct logger_handle_st LOGGER_HANDLE;
extern struct logger_service_st {
  void (*logger_init_mutexes)();
  LOGGER_HANDLE* (*open)(const char *path,
                         unsigned long long size_limit,
                         unsigned int rotations);
  int (*close)(LOGGER_HANDLE *log);
  int (*vprintf)(LOGGER_HANDLE *log, const char *fmt, va_list argptr);
  int (*printf)(LOGGER_HANDLE *log, const char *fmt, ...);
  int (*write)(LOGGER_HANDLE *log, const char *buffer, size_t size);
  int (*rotate)(LOGGER_HANDLE *log);
} *logger_service;
  void logger_init_mutexes();
  LOGGER_HANDLE *logger_open(const char *path,
                             unsigned long long size_limit,
                             unsigned int rotations);
  int logger_close(LOGGER_HANDLE *log);
  int logger_vprintf(LOGGER_HANDLE *log, const char *fmt, va_list argptr);
  int logger_printf(LOGGER_HANDLE *log, const char *fmt, ...);
  int logger_write(LOGGER_HANDLE *log, const char *buffer, size_t size);
  int logger_rotate(LOGGER_HANDLE *log);
#include <mysql/service_thd_autoinc.h>
extern struct thd_autoinc_service_st {
  void (*thd_get_autoinc_func)(const void* thd,
                               unsigned long* off, unsigned long* inc);
} *thd_autoinc_service;
void thd_get_autoinc(const void* thd,
                     unsigned long* off, unsigned long* inc);
#include <mysql/service_thd_error_context.h>
extern struct thd_error_context_service_st {
  const char *(*thd_get_error_message_func)(const void* thd);
  unsigned int (*thd_get_error_number_func)(const void* thd);
  unsigned long (*thd_get_error_row_func)(const void* thd);
  void (*thd_inc_error_row_func)(void* thd);
  char *(*thd_get_error_context_description_func)(void* thd,
                                                  char *buffer,
                                                  unsigned int length,
                                                  unsigned int max_query_length);
} *thd_error_context_service;
const char *thd_get_error_message(const void* thd);
unsigned int thd_get_error_number(const void* thd);
unsigned long thd_get_error_row(const void* thd);
void thd_inc_error_row(void* thd);
char *thd_get_error_context_description(void* thd,
                                        char *buffer, unsigned int length,
                                        unsigned int max_query_length);
#include <mysql/service_thd_specifics.h>
typedef int MYSQL_THD_KEY_T;
extern struct thd_specifics_service_st {
  int (*thd_key_create_func)(MYSQL_THD_KEY_T *key);
  void (*thd_key_delete_func)(MYSQL_THD_KEY_T *key);
  void *(*thd_getspecific_func)(void* thd, MYSQL_THD_KEY_T key);
  int (*thd_setspecific_func)(void* thd, MYSQL_THD_KEY_T key, void *value);
} *thd_specifics_service;
int thd_key_create(MYSQL_THD_KEY_T *key);
void thd_key_delete(MYSQL_THD_KEY_T *key);
void* thd_getspecific(void* thd, MYSQL_THD_KEY_T key);
int thd_setspecific(void* thd, MYSQL_THD_KEY_T key, void *value);
#include <mysql/service_encryption_keys.h>
typedef int (*encrypt_decrypt_func)(const unsigned char* src, unsigned int slen,
                                    unsigned char* dst, unsigned int* dlen,
                                    const unsigned char* key, unsigned int klen,
                                    const unsigned char* iv, unsigned int ivlen,
                                    int no_padding, unsigned int key_version);
struct encryption_keys_service_st {
  unsigned int (*get_latest_encryption_key_version_func)();
  unsigned int (*has_encryption_key_func)(unsigned int);
  unsigned int (*get_encryption_key_func)(unsigned int, unsigned char*, unsigned int*);
  encrypt_decrypt_func encrypt_data_func;
  encrypt_decrypt_func decrypt_data_func;
};
extern struct encryption_keys_service_st encryption_keys_handler;
struct st_mysql_xid {
  long formatID;
  long gtrid_length;
  long bqual_length;
  char data[128];
};
typedef struct st_mysql_xid MYSQL_XID;
enum enum_mysql_show_type
{
  SHOW_UNDEF, SHOW_BOOL, SHOW_UINT, SHOW_ULONG,
  SHOW_ULONGLONG, SHOW_CHAR, SHOW_CHAR_PTR,
  SHOW_ARRAY, SHOW_FUNC, SHOW_DOUBLE,
  SHOW_SINT, SHOW_SLONG, SHOW_SLONGLONG, SHOW_SIMPLE_FUNC,
  SHOW_always_last
};
enum enum_var_type
{
  SHOW_OPT_DEFAULT= 0, SHOW_OPT_SESSION, SHOW_OPT_GLOBAL
};
struct st_mysql_show_var {
  const char *name;
  void *value;
  enum enum_mysql_show_type type;
};
typedef int (*mysql_show_var_func)(void*, struct st_mysql_show_var*, void *, enum enum_var_type);
struct st_mysql_sys_var;
struct st_mysql_value;
typedef int (*mysql_var_check_func)(void* thd,
                                    struct st_mysql_sys_var *var,
                                    void *save, struct st_mysql_value *value);
typedef void (*mysql_var_update_func)(void* thd,
                                      struct st_mysql_sys_var *var,
                                      void *var_ptr, const void *save);
struct st_mysql_plugin
{
  int type;
  void *info;
  const char *name;
  const char *author;
  const char *descr;
  int license;
  int (*init)(void *);
  int (*deinit)(void *);
  unsigned int version;
  struct st_mysql_show_var *status_vars;
  struct st_mysql_sys_var **system_vars;
  void * __reserved1;
  unsigned long flags;
};
struct st_maria_plugin
{
  int type;
  void *info;
  const char *name;
  const char *author;
  const char *descr;
  int license;
  int (*init)(void *);
  int (*deinit)(void *);
  unsigned int version;
  struct st_mysql_show_var *status_vars;
  struct st_mysql_sys_var **system_vars;
  const char *version_info;
  unsigned int maturity;
};
#include "plugin_ftparser.h"
#include "plugin.h"
enum enum_ftparser_mode
{
  MYSQL_FTPARSER_SIMPLE_MODE= 0,
  MYSQL_FTPARSER_WITH_STOPWORDS= 1,
  MYSQL_FTPARSER_FULL_BOOLEAN_INFO= 2
};
enum enum_ft_token_type
{
  FT_TOKEN_EOF= 0,
  FT_TOKEN_WORD= 1,
  FT_TOKEN_LEFT_PAREN= 2,
  FT_TOKEN_RIGHT_PAREN= 3,
  FT_TOKEN_STOPWORD= 4
};
typedef struct st_mysql_ftparser_boolean_info
{
  enum enum_ft_token_type type;
  int yesno;
  int weight_adjust;
  char wasign;
  char trunc;
  char prev;
  char *quot;
} MYSQL_FTPARSER_BOOLEAN_INFO;
typedef struct st_mysql_ftparser_param
{
  int (*mysql_parse)(struct st_mysql_ftparser_param *,
                     const char *doc, int doc_len);
  int (*mysql_add_word)(struct st_mysql_ftparser_param *,
                        const char *word, int word_len,
                        MYSQL_FTPARSER_BOOLEAN_INFO *boolean_info);
  void *ftparser_state;
  void *mysql_ftparam;
  const struct charset_info_st *cs;
  const char *doc;
  int length;
  unsigned int flags;
  enum enum_ftparser_mode mode;
} MYSQL_FTPARSER_PARAM;
struct st_mysql_ftparser
{
  int interface_version;
  int (*parse)(MYSQL_FTPARSER_PARAM *param);
  int (*init)(MYSQL_FTPARSER_PARAM *param);
  int (*deinit)(MYSQL_FTPARSER_PARAM *param);
};
struct st_mysql_daemon
{
  int interface_version;
};
struct st_mysql_information_schema
{
  int interface_version;
};
struct st_mysql_storage_engine
{
  int interface_version;
};
struct handlerton;
 struct Mysql_replication {
   int interface_version;
 };
struct st_mysql_value
{
  int (*value_type)(struct st_mysql_value *);
  const char *(*val_str)(struct st_mysql_value *, char *buffer, int *length);
  int (*val_real)(struct st_mysql_value *, double *realbuf);
  int (*val_int)(struct st_mysql_value *, long long *intbuf);
  int (*is_unsigned)(struct st_mysql_value *);
};
int thd_in_lock_tables(const void* thd);
int thd_tablespace_op(const void* thd);
long long thd_test_options(const void* thd, long long test_options);
int thd_sql_command(const void* thd);
void **thd_ha_data(const void* thd, const struct handlerton *hton);
void thd_storage_lock_wait(void* thd, long long value);
int thd_tx_isolation(const void* thd);
int thd_tx_is_read_only(const void* thd);
int thd_rpl_is_parallel(const void* thd);
int mysql_tmpfile(const char *prefix);
unsigned long thd_get_thread_id(const void* thd);
void thd_get_xid(const void* thd, MYSQL_XID *xid);
void mysql_query_cache_invalidate4(void* thd,
                                   const char *key, unsigned int key_length,
                                   int using_trx);
void *thd_get_ha_data(const void* thd, const struct handlerton *hton);
void thd_set_ha_data(void* thd, const struct handlerton *hton,
                     const void *ha_data);
void thd_wakeup_subsequent_commits(void* thd, int wakeup_error);
#include <mysql/plugin_auth_common.h>
typedef struct st_plugin_vio_info
{
  enum { MYSQL_VIO_INVALID, MYSQL_VIO_TCP, MYSQL_VIO_SOCKET,
         MYSQL_VIO_PIPE, MYSQL_VIO_MEMORY } protocol;
  int socket;
} MYSQL_PLUGIN_VIO_INFO;
typedef struct st_plugin_vio
{
  int (*read_packet)(struct st_plugin_vio *vio,
                     unsigned char **buf);
  int (*write_packet)(struct st_plugin_vio *vio,
                      const unsigned char *packet,
                      int packet_len);
  void (*info)(struct st_plugin_vio *vio, struct st_plugin_vio_info *info);
} MYSQL_PLUGIN_VIO;
typedef struct st_mysql_server_auth_info
{
  char *user_name;
  unsigned int user_name_length;
  const char *auth_string;
  unsigned long auth_string_length;
  char authenticated_as[512 +1];
  char external_user[512 +1];
  int password_used;
  const char *host_or_ip;
  unsigned int host_or_ip_length;
} MYSQL_SERVER_AUTH_INFO;
struct st_mysql_auth
{
  int interface_version;
  const char *client_auth_plugin;
  int (*authenticate_user)(MYSQL_PLUGIN_VIO *vio, MYSQL_SERVER_AUTH_INFO *info);
};
