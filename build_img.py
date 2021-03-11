import os
import subprocess
import jinja2
from datetime import date


PROJECT_PATH = os.path.dirname(os.path.realpath(__file__))

# load jinja templates
template_path = os.path.join(PROJECT_PATH, 'templates')
template_loader = jinja2.FileSystemLoader(searchpath=template_path)
template_env = jinja2.Environment(loader=template_loader, keep_trailing_newline=True)


def render_template(src, dest, template_vars=None):
    """
    helper function fo rendering jinja template
    :param src: relative string path to jinja template file
    :param dest: absolute string path of output destination file
    :param template_vars: variables to render template with
    :return: None
    """
    template = template_env.get_template(src)
    if not template_vars:
        template_vars= {}
    output_text = template.render(**template_vars)
    if os.path.exists(dest):
        os.remove(dest)
    with open(dest, 'w') as f:
        f.write(output_text)

# remove old files
os.remove(os.path.join(PROJECT_PATH, 'raspi_3.img'))
os.remove(os.path.join(PROJECT_PATH, 'raspi_3.log'))

# build img
subprocess.check_call(['make', 'raspi_3.img'])

# create releases dir
today = date.today()
today_str = "{}{}{}".format(today.year, today.month, today.day)
release_dir = "/var/www/releases.peachcloud.org/html/peach-imgs/{}".format(today_str)
os.makedirs(release_dir)

# copy image and log to releases dir
print("++ successful image build, copying output to {}", release_dir)
img_path = os.path.join(PROJECT_PATH, 'raspi_3.img')
log_path = os.path.join(PROJECT_PATH, 'raspi_3.log')
release_img_name = "{}_peach_raspi3.img".format(today_str)
release_log_name = "{}_peach_raspi3.log".format(today_str)
img_release_path = os.path.join(release_dir, release_img_name)
log_release_path = os.path.join(release_dir, release_log_name)
subprocess.check_call(['cp',  img_path, img_release_path])
subprocess.check_call(['cp',  log_path, log_release_path])

# rebuild release index.html
release_index_path = "/var/www/releases.peachcloud.org/html/index.html"
release_img_url = img_release_path.replace('/var/www/releases.peachcloud.org/html/', '/')
render_template(
    src="release_index.html",
    dest=release_index_path,
    template_vars={
        "release_img_url": release_img_url,
        "release_img_name": release_img_name,
    }
)