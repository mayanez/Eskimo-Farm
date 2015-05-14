/*
 * Device driver for the Audio Controller
 *
 * A Platform device implemented using the misc subsystem
 *
 * Originally modified from Stephen A. Edwards Lab3 Code.
 * Columbia University
 *
 * References:
 * Linux source: Documentation/driver-model/platform.txt
 *               drivers/misc/arm-charlcd.c
 * http://www.linuxforu.com/tag/linux-device-drivers/
 * http://free-electrons.com/docs/
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "audio_hw.h"

#define DRIVER_NAME "audio_hw"

/*
 * Information about our device
 */
struct audio_hw_dev {
	struct resource res; /* Resource: our registers */
	void __iomem *virtbase; /* Where registers can be accessed in memory */
} dev;


/*
 * Handle ioctl() calls from userspace:
 */
static long audio_hw_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
    unsigned int control;

	switch (cmd) {
		case AUDIO_SET_CONTROL:
			if (copy_from_user(&control, (unsigned int *) arg, sizeof(unsigned int)))
				return -EACCES;
			iowrite32(control, dev.virtbase);
			break;
        case AUDIO_MUTE:
			iowrite32(0, dev.virtbase);
            break;
		default:
			return -EINVAL;
	}

	return 0;
}

/* The operations our device knows how to do */
static const struct file_operations audio_hw_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl = audio_hw_ioctl,
};

/* Information about our device for the "misc" framework -- like a char dev */
static struct miscdevice audio_hw_misc_device = {
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME,
	.fops		= &audio_hw_fops,
};

/*
 * Initialization code: get resources (registers) and display
 * a welcome message
 */
static int __init audio_hw_probe(struct platform_device *pdev)
{
	int ret;

	/* Register ourselves as a misc device */
	ret = misc_register(&audio_hw_misc_device);

	/* Get the address of our registers from the device tree */
	ret = of_address_to_resource(pdev->dev.of_node, 0, &dev.res);
	if (ret) {
		ret = -ENOENT;
		goto out_deregister;
	}

	/* Make sure we can use these registers */
	if (request_mem_region(dev.res.start, resource_size(&dev.res),
			       DRIVER_NAME) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

	/* Arrange access to our registers */
	dev.virtbase = of_iomap(pdev->dev.of_node, 0);
	if (dev.virtbase == NULL) {
		ret = -ENOMEM;
		goto out_release_mem_region;
	}

	return 0;

out_release_mem_region:
	release_mem_region(dev.res.start, resource_size(&dev.res));
out_deregister:
	misc_deregister(&audio_hw_misc_device);
	return ret;
}

/* Clean-up code: release resources */
static int audio_hw_remove(struct platform_device *pdev)
{
	iounmap(dev.virtbase);
	release_mem_region(dev.res.start, resource_size(&dev.res));
	misc_deregister(&audio_hw_misc_device);
	return 0;
}

/* Which "compatible" string(s) to search for in the Device Tree */
#ifdef CONFIG_OF
static const struct of_device_id audio_hw_of_match[] = {
	{ .compatible = "altr,audio_hw" },
	{},
};
MODULE_DEVICE_TABLE(of, audio_hw_of_match);
#endif

/* Information for registering ourselves as a "platform" driver */
static struct platform_driver audio_hw_driver = {
	.driver	= {
		.name	= DRIVER_NAME,
		.owner	= THIS_MODULE,
		.of_match_table = of_match_ptr(audio_hw_of_match),
	},
	.remove	= __exit_p(audio_hw_remove),
};

/* Called when the module is loaded: set things up */
static int __init audio_hw_init(void)
{
	pr_info(DRIVER_NAME ": init\n");
	return platform_driver_probe(&audio_hw_driver, audio_hw_probe);
}

/* Called when the module is unloaded: release resources */
static void __exit audio_hw_exit(void)
{
	platform_driver_unregister(&audio_hw_driver);
	pr_info(DRIVER_NAME ": exit\n");
}

module_init(audio_hw_init);
module_exit(audio_hw_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Miguel A. Yanez, Columbia University");
MODULE_DESCRIPTION("Audio Hardware Driver");
