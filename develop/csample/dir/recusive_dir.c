#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <dirent.h>
/*
 *  struct dirent {
 *  ino_t          d_ino;        inode number 
 *  off_t          d_off;        not an offset; see NOTES 
 *  unsigned short d_reclen;     length of this record 
 *  unsigned char  d_type;       type of file; not supported
 *                               by all file system types 
 *   char           d_name[256]; filename 
 *  };
 */

// d_type discription
/*
*DT_UNKNOWN
*The type is unknown. Only some filesystems have full support to return the type of the file, others might always return this value.
*
*DT_REG
*A regular file.
*
*DT_DIR
*A directory.
*
*DT_FIFO
*A named pipe, or FIFO. See FIFO Special Files.
*
*DT_SOCK
*A local-domain socket.
*
*DT_CHR
*A character device.
*
*DT_BLK
*A block device.
*
*DT_LNK
*A symbolic link.
*/ 
/*
 * http://pubs.opengroup.org/onlinepubs/7908799/xsh/sysstat.h.html
*The following macros will test whether a file is of the specified type. The value m supplied to the macros is the value of st_mode from a stat structure. The macro evaluates to a non-zero value if the test is true, 0 if the test is false.
*
*S_ISBLK(m)
*Test for a block special file.
*S_ISCHR(m)
*Test for a character special file.
*S_ISDIR(m)
*Test for a directory.
*S_ISFIFO(m)
*Test for a pipe or FIFO special file.
*S_ISREG(m)
*Test for a regular file.
*S_ISLNK(m)
*Test for a symbolic link.
*/

/*
 *recusive traversal the directory
 */
void listdir(char *path, size_t size) {
    DIR *dir;
    struct dirent *entry;
    size_t len = strlen(path);

    if (!(dir = opendir(path))) {
        fprintf(stderr, "path not found: %s: %s\n",
                path, strerror(errno));
        return;
    }

    puts(path);
    while ((entry = readdir(dir)) != NULL) {
        char *name = entry->d_name;
	//printf("d_type is %s\n", entry->d_type);
        if (entry->d_type == DT_DIR) {
            if (!strcmp(name, ".") || !strcmp(name, ".."))
                continue;
            if (len + strlen(name) + 2 > size) {
                fprintf(stderr, "path too long: %s/%s\n", path, name);
            } else {
                path[len] = '/';
                strcpy(path + len + 1, name);
                listdir(path, size);
                path[len] = '\0';
            }
        } else {
            printf("%s/%s\n", path, name);
        }
    }
    closedir(dir);
}

int main(void) {
    char path[1024] = "/dev";
    listdir(path, sizeof path);
    return 0;
}
