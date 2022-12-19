import subprocess

kwargs = {
    'stdout': subprocess.PIPE,
    'stderr': subprocess.STDOUT,
}
proc = subprocess.Popen(['php-fpm', '-y', 'fpm.conf'], **kwargs)
out, err = proc.communicate()
print(out, err)
