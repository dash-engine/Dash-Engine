from sys import argv
from PIL import Image
from os import getcwd, path, makedirs

class PyImg2GD:
    def __init__(self, img_path: str, name: str, where: str):
        '''
        img_path: string
            The image path
        name: string
            The base name for output files
        where: string
            The directory to save output files
        '''
        self.cwd = where if where else getcwd()
        if not path.exists(self.cwd):
            makedirs(self.cwd)
        self.img = img_path
        self.width = 80
        self.height = 80
        self.name = name
        self.fourbit_convert()

    def write_values(self):
        '''
        This function will write the
        image data values
        '''
        output_file = path.join(self.cwd, f"{self.name}.txt")
        with open(output_file, "w+") as txt:
            txt.write(f'{self.width} x {self.height}/{self.pix_values()}')

    def fourbit_convert(self):
        with Image.open(self.img) as img:
            nimg = img.convert("P", palette=Image.ADAPTIVE, colors=32)
            fixed_height = 100
            height_percent = (fixed_height / float(nimg.size[1]))
            width_size = int((float(nimg.size[0]) * float(height_percent)))
            nimg = nimg.resize((width_size, fixed_height), Image.LANCZOS)
            self.width, self.height = nimg.width, nimg.height
            output_img_path = path.join(self.cwd, f'{self.name}-16bit.png')
            nimg.save(output_img_path, format="png")

    def pix_values(self):
        '''
        This function will return the
        rgb value of each pixel in an image
        '''
        pix = ""
        img_path = path.join(self.cwd, f'{self.name}-16bit.png')
        with Image.open(img_path) as img:
            for x in range(img.width):
                for y in range(img.height):
                    nimg = img.convert("RGBA").transpose(method=Image.FLIP_LEFT_RIGHT)
                    current_pixel = nimg.getpixel((img.width-x-1, img.height-y-1))
                    if len(current_pixel) == 4:
                        pix += f'{current_pixel[0]} {current_pixel[1]} {current_pixel[2]} {current_pixel[3]}/'
                    else:
                        pix += f'{current_pixel[0]} {current_pixel[1]} {current_pixel[2]} 255/'
                    print(f'x: {x}, y: {y}, width: {self.width}, height: {self.height}', end="\r")
        print()
        return pix

if __name__ == "__main__":
    if len(argv) < 4:
        print("Usage: script.py <image_path> <name> <output_directory>")
        exit(1)

    image = argv[1]
    name = argv[2]
    where = argv[3]

    for possible_extension in ['png', 'jpg', 'jpeg', 'bmp', 'gif', 'svg']:
        if possible_extension in image.lower():
            image_object = PyImg2GD(image, name, where)
            print(f'Writing data in {where}/{name}.txt')
            image_object.write_values()
            exit()

    print("Invalid file")
