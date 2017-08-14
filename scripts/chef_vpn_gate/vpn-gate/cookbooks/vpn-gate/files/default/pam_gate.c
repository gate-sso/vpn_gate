// standard stuff
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <syslog.h>


#include <security/pam_ext.h>


// pam stuff
#include <security/pam_modules.h>

// libcurl
#include <curl/curl.h>
#include <security/pam_appl.h>

/* expected hook */
PAM_EXTERN int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    return PAM_CRED_UNAVAIL;
}


struct gate_response_string {
    char *ptr;
    size_t len;
};

void init_string(struct gate_response_string *s) {
    s->len = 0;
    s->ptr = malloc(s->len + 1);
    if (s->ptr == NULL) {
        exit(EXIT_FAILURE);
    }
    s->ptr[0] = '\0';
}

/*
 * Makes getting arguments easier. Accepted arguments are of the form: name=value
 *
 * @param pName- name of the argument to get
 * @param argc- number of total arguments
 * @param argv- arguments
 * @return Pointer to value or NULL
 */
static const char *getArg(const char *pName, int argc, const char **argv) {
    int len = strlen(pName);
    int i;

    for (i = 0; i < argc; i++) {
        if (strncmp(pName, argv[i], len) == 0 && argv[i][len] == '=') {
            // only give the part url part (after the equals sign)
            return argv[i] + len + 1;
        }
    }
    return 0;
}

/*
 * Function to handle stuff from HTTP response.
 *
 * @param buf- Raw buffer from libcurl.
 * @param len- number of indices
 * @param size- size of each index
 * @param userdata- any extra user data needed
 * @return Number of bytes actually handled. If different from len * size, curl will throw an error
 */
static int writeFn(void *buf, size_t len, size_t size, struct gate_response_string *s) {

    size_t new_len = s->len + len * size;
    s->ptr = realloc(s->ptr, new_len + 1);
    if (s->ptr == NULL) {
        exit(EXIT_FAILURE);
    }
    memcpy(s->ptr + s->len, buf, size * len);
    s->ptr[new_len] = '\0';
    s->len = new_len;


    return len * size;
}


static int getUrlWithUser(const char *pUrl, const char *pCaFile) {

    CURL *pCurl = curl_easy_init();
    int res = -1;


    if (!pCurl) {
        return 0;
    }

    struct gate_response_string s;
    init_string(&s);

    //printf("URL: %s\n", pUrl);

    curl_easy_setopt(pCurl, CURLOPT_URL, pUrl);
    curl_easy_setopt(pCurl, CURLOPT_WRITEFUNCTION, writeFn);
    curl_easy_setopt(pCurl, CURLOPT_WRITEDATA, &s);

    //curl_easy_setopt(pCurl, CURLOPT_USERPWD, pUserPass);
    curl_easy_setopt(pCurl, CURLOPT_NOPROGRESS, 1); // we don't care about progress
    curl_easy_setopt(pCurl, CURLOPT_FAILONERROR, 1);
    // we don't want to leave our user waiting at the login prompt forever
    curl_easy_setopt(pCurl, CURLOPT_TIMEOUT, 1);

    // SSL needs 16k of random stuff. We'll give it some space in RAM.
    curl_easy_setopt(pCurl, CURLOPT_RANDOM_FILE, "/dev/urandom");
    curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYPEER, 0);
    curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYHOST, 0);
    curl_easy_setopt(pCurl, CURLOPT_USE_SSL, CURLUSESSL_ALL);




    // synchronous, but we don't really care
    res = curl_easy_perform(pCurl);
    curl_easy_cleanup(pCurl);
    //printf("Res: %s\n", s.ptr);
    //printf("Res Integer: %d\n", atoi(s.ptr));


    res = atoi(s.ptr);

    //printf("Result %s Length %d\n", s.ptr, (int)strlen(s.ptr));
    if (strlen(s.ptr) == 0)
        res = 1;

    return res;
}

int get_ip_addresses(char **addresses) {
    struct ifaddrs *ifap, *ifa;
    struct sockaddr_in *sa;
    char *addr;
    char ip_addresses[100][20];
    getifaddrs(&ifap);
    int addr_counter = 0;
    int addr_mem = 0;
    char *ip_fmt_str;
    int count = 0;
    for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
        if (ifa->ifa_addr->sa_family == AF_INET) {
            sa = (struct sockaddr_in *) ifa->ifa_addr;
            addr = inet_ntoa(sa->sin_addr);
            if (strncmp(addr, (const char *) "127.0.0.1", strlen("127.0.0.1"))) {
                strcpy(ip_addresses[addr_counter], addr);
                addr_counter++;
            }

        }
    }

    addr_mem = (16 * addr_counter) + 1;
    ip_fmt_str = (char *) malloc(addr_mem);
    *addresses = (char *) malloc(addr_mem);
    memset(ip_fmt_str, 0, addr_mem);

    //strcat(ip_fmt_str, (const char *) "[");



    for (count = 0; count < addr_counter; count++) {
        //strcat(ip_fmt_str, (const char *) "\"");
        strcat(ip_fmt_str, (const char *) ip_addresses[count]);
        //strcat(ip_fmt_str, (const char *) "\"");
        strcat(ip_fmt_str, (const char *) ",");
    }
    ip_fmt_str[strlen(ip_fmt_str) - 1] = '\0';
    //printf("returning ip_fmt_str %s\n", ip_fmt_str);
    strcpy(*addresses, ip_fmt_str);
    free(ip_fmt_str);
    freeifaddrs(ifap);
    //printf("returning addr_counter %s\n", *addresses);
    return addr_counter;
}

PAM_EXTERN int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv) {

    int ret = PAM_SUCCESS;

    const char *pUsername = NULL;
    const char *pUrl = NULL;
    const char *pCaFile = NULL;
    const char *pToken = NULL;

    char pUrlWithUser[1000];


    char *ip_addresses;

    pToken = getArg("token", argc, argv);
    pUrl = getArg("url", argc, argv);

    memset(pUrlWithUser, 0, 1000);

    if (pam_get_user(pamh, &pUsername, NULL) != 0) {
        ret = PAM_USER_UNKNOWN;
    }

    get_ip_addresses(&ip_addresses);

    sprintf(pUrlWithUser, "%s/profile/verify?token=%s&user=%s&addresses=%s", pUrl, pToken, pUsername, ip_addresses);
    pam_syslog(pamh, LOG_ERR, "pam_gate authentication for %s at %s for host %s", pUsername, pUrl, ip_addresses);
    pam_syslog(pamh, LOG_ERR, "pam_gate authentication performing at %s", pUrlWithUser);

    if (getUrlWithUser(pUrlWithUser, pCaFile) != 0) {
        ret = PAM_USER_UNKNOWN;
    }

    return ret;
}

static char *get_first_pass(pam_handle_t *pamh) {
    const void *password = NULL;
    if (pam_get_item(pamh, PAM_AUTHTOK, &password) == PAM_SUCCESS &&
        password) {
        return strdup((const char *) password);
    }
    return NULL;
}

static int get_user_id(const char *sUsername, const char *sUrl, const char *sToken) {
    char pUrlWithUser[1000];
    sprintf(pUrlWithUser, "%s/profile/%s/id?token=%s", sUrl, sUsername, sToken);
    return getUrlWithUser(pUrlWithUser, NULL);
}

/* expected hook, this is where custom stuff happens */
PAM_EXTERN int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv) {
    int ret = 0;

    const char *pUsername = NULL;
    const char *pUrl = NULL;

    const char *pCaFile = NULL;

    //default
    int MIN_CONST = 2000;
    int pMinUserId = 0;

    char pUrlWithUser[1000];

    struct pam_message msg;
    struct pam_conv *pItem;
    struct pam_response *pResp;
    const struct pam_message *pMsg = &msg;
    const char *pToken;
    const char *pPassword;

    char *ip_addresses;
    int iUserId;

    pMinUserId = atoi(getArg("min_user_id", argc, argv));

    if (pMinUserId == 0)
        pMinUserId = MIN_CONST;

    pUrl = getArg("url", argc, argv);
    pToken = getArg("token", argc, argv);
    pCaFile = getArg("cafile", argc, argv);

    if (!pUrl && !pToken) {
        return PAM_AUTH_ERR;
    }

    if (pam_get_user(pamh, &pUsername, NULL) != PAM_SUCCESS) {
        return PAM_AUTH_ERR;
    }

    iUserId = get_user_id(pUsername, pUrl, pToken);

    if (iUserId <= pMinUserId)
        return PAM_USER_UNKNOWN;

    //Try get password
    pPassword = get_first_pass(pamh);

    //We got password that means we are not doing conversation
    memset(pUrlWithUser, 0, 1000);
    if (pPassword) {
        sprintf(pUrlWithUser, "%s/profile/authenticate?user=%s&password=%s", pUrl, pUsername, pPassword);
        if (getUrlWithUser(pUrlWithUser, pCaFile) != 0) {
            return PAM_AUTH_ERR;
        }
    }

    //This means we are not getting password already
    //Ask user for password.

    msg.msg_style = PAM_PROMPT_ECHO_OFF;
    msg.msg = "MFA Token: ";

    if (pam_get_item(pamh, PAM_CONV, (const void **) &pItem) != PAM_SUCCESS || !pItem) {
        return PAM_AUTH_ERR;
    }

    pItem->conv(1, &pMsg, &pResp, pItem->appdata_ptr);

    ret = PAM_SUCCESS;

    memset(pUrlWithUser, 0, 1000);

    get_ip_addresses(&ip_addresses);

    sprintf(pUrlWithUser, "%s/profile/authenticate_pam?user=%s&password=%s&addresses=%s", pUrl, pUsername,
            pResp[0].resp, ip_addresses);
    free(ip_addresses);
    if (getUrlWithUser(pUrlWithUser, pCaFile) != 0) {
        ret = PAM_AUTH_ERR;
    }
    memset(pResp[0].resp, 0, strlen(pResp[0].resp));
    free(pResp);
    return ret;
}
