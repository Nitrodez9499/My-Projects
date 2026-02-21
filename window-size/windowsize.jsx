import React, { useState, useEffect } from ‘react’;

export default function WindowSize() {
const [dimensions, setDimensions] = useState({
width: window.innerWidth,
height: window.innerHeight
});

useEffect(() => {
const handleResize = () => {
setDimensions({
width: window.innerWidth,
height: window.innerHeight
});
};

```
window.addEventListener('resize', handleResize);
return () => window.removeEventListener('resize', handleResize);
```

}, []);

return (
<div className="flex items-center justify-center min-h-screen bg-white dark:bg-black transition-colors">
<div className="text-gray-600 dark:text-gray-400 text-6xl font-light tracking-wide">
{dimensions.width} × {dimensions.height}
</div>
</div>
);
}
