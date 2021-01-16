.float message_time;
.float message_brelease;

void() readable_think = 
{
	self.colormod = '1 0 1';
};
void() func_readable = 
{
	self.classname = "readable";
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.usable = 1;
};
///////////