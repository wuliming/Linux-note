/*
 * get the ttyname 
 */
#include <sys/stat.h>
#include <dirent.h>
#include <ctype.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>

char *
get_ttyname_info(int pid, dev_t dev, char *devpath)
{
    struct stat statbuf;
    char fullpath[1024];
    static char ttyname[1024];
    char *path;
    struct dirent *drp;
    DIR *rundir;
    strcpy(ttyname, "?");
    int re;
    if ((rundir = opendir(devpath)) == NULL)
	return ttyname;
    puts(devpath);
    while ((drp = readdir(rundir)) != NULL) {
	if (*(path = &drp->d_name[0]) == '.')
		continue;
	
	snprintf(fullpath, sizeof(fullpath), "%s/%s", devpath, path);
	fullpath[sizeof(fullpath)-1] = '\0';
        if (drp->d_type == DT_DIR) {
	    if(strcmp(get_ttyname_info(pid, dev, fullpath), "?") != 0) return ttyname;
        }
	else{
		if(!stat(fullpath, &statbuf)){
                	printf("fail to get stat of path : %s\n", fullpath);
		}
		if (S_ISCHR(statbuf.st_mode) &&  drp->d_type != DT_LNK && dev == statbuf.st_rdev) {
	    	strncpy(ttyname, &fullpath[5], sizeof(ttyname));
	    	ttyname[sizeof(ttyname)-1] = '\0';
	    	break;
		}
	}
    }
    closedir(rundir);
    return ttyname;
}

int main()
{
	char pathtemp[108] = "/dev";
	char * info="8888ss";
	int pid=2601;
	dev_t dev=1025; 
 	info = get_ttyname_info(pid, dev, pathtemp);
	printf("ttyname of pid is: %d, %s\n", pid, info);
}

/*
*           struct stat {
*               dev_t     st_dev;      ID of device containing file 
*               ino_t     st_ino;      inode number 
*               mode_t    st_mode;     protection 
*               nlink_t   st_nlink;    number of hard links 
*               uid_t     st_uid;      user ID of owner 
*               gid_t     st_gid;      group ID of owner 
*               dev_t     st_rdev;     device ID (if special file) 
*               off_t     st_size;     total size, in bytes 
*               blksize_t st_blksize;  blocksize for file system I/O 
*               blkcnt_t  st_blocks;   number of 512B blocks allocated 
*               time_t    st_atime;    time of last access 
*               time_t    st_mtime;    time of last modification 
*               time_t    st_ctime;    time of last status change 
*           };
*/
