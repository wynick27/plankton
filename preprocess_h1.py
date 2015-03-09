#transform the data into classes of hierarchy 1
import re

class PlanktonPreprocess(object):
    def __init__(self,class_file,feature_file):
        self.all_class = set()
        self.class_dict = dict()
        self.make_hierarchy1_dict(class_file)
        #self.transform_dir_to_h1(feature_file)
        self.transform_dir(feature_file)

    def make_hierarchy1_dict(self,class_file):
        with open(class_file,'r') as f_class:
            for line in f_class:
                class_name,subs = line.split('\t')
                subs = subs.split(',')
                subs[-1] = subs[-1][:-1]
                sub_str = []
                for sub in subs:
                    match = re.search('"(.*)"', sub)
                    if (match):
                        sub_str.append(match.group(1))
                    else:
                        sub_str.append(re.subn(' ','_',sub.strip())[0])
                self.class_dict[class_name[:-1]] = sub_str
        #print self.class_dict
    def transform_dir_to_h1(self,feature_file):
        output_file = open('plankton_features_v02.arff','w')
        #counter = 0
        with open(feature_file,'r') as f_feat:
            for line in f_feat:
                match = re.search('"(.*)"',line)
                dir_str = match.group(1)
                h1_str = self.h1_match(dir_str)
                result_line = re.sub('"(.*)", ','',line)
                output_file.write(result_line[:-1] + ', ' + h1_str +'\n')
                #if (counter % 1000): print counter

    def transform_dir(self,feature_file):
        output_file = open('plankton_features_all_class.arff','w')
        #counter = 0
        with open(feature_file,'r') as f_feat:
            for line in f_feat:
                match = re.search('"(.*)"',line)
                dir_str = match.group(1)
                h1_str = self.get_class_from_dir(dir_str)
                result_line = re.sub('"(.*)", ','',line)
                output_file.write(result_line[:-1] + ', ' + h1_str +'\n')
                #break

    def get_class_from_dir(self,directory):
        match = re.match('(.*?)/.*',directory)
        #print match.group(1)
        self.all_class.add(match.group(1))
        return match.group(1)

    def h1_match(self,dir_str):
        for class_name,sub_strs in self.class_dict.items():
            for sub_str in sub_strs:
                match = re.search(sub_str,dir_str)
                if (match):
                    if (sub_str == 'larvae'):
                        match_fish = re.search('fish',dir_str)
                        if (match_fish): return '"' + 'fish' + '"'
                    return '"' + class_name + '"'
        print "Error: No class found----",dir_str
if __name__ == '__main__':
    pp = PlanktonPreprocess('../h1_class','feature_data.txt')
    print len(pp.all_class)
    f=open('all_classes.txt','w')
    for p_class in pp.all_class:
        f.write(p_class + ', ')
    f.close()
