import os
import sys
import jinja2
import json


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


def publish_img(release_dir):
    """
    takes in a string path to a directory containing a release

    it expected the directory to be named YEARMONTHDAY
    and to contain the following three files:
    - YEARMONTHDAY_peach_raspi3.img.xz
    - YEARMONTHDAY_peach_raspi3.log
    - YEARMONTHDAY_peach_manifest.log

    The script re-builds index.html for releases.peachcloud.org to point to
    the files in this releases directory.
    """
    # get release name (last part of path)
    release_name = os.path.basename(os.path.normpath(release_dir))

    # expected file paths within release_dir
    img_name = "{}_peach_raspi3.img.xz".format(release_name)
    img_path = os.path.join(release_dir, img_name)
    manifest_path = os.path.join(release_dir, "{}_peach_manifest.log".format(release_name))

    # rebuild index.html to point to the new release
    release_index_path = "/var/www/releases.peachcloud.org/html/index.html"
    release_img_url = img_path.replace('/var/www/releases.peachcloud.org/html/', '/')
    with open(manifest_path, 'r') as f:
        manifest = json.loads(f.read())
    for k, v in manifest.items():
        print("{}: {}".format(k, v))
    packages = manifest['packages']
    render_template(
        src="release_index.html",
        dest=release_index_path,
        template_vars={
            "release_img_url": release_img_url,
            "release_img_name": img_name,
            "packages": packages
        }
    )


if __name__ == '__main__':
    publish_img(sys.argv[1])