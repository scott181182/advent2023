


class MyPriorityQueue<T, V extends Comparable<V>> {
    ArrayList<KeyEntry> list
    PriorityQueue<KeyEntry> queue

    public MyPriorityQueue() {
        this.list = new ArrayList<>()
        this.queue = new PriorityQueue<>()
    }

    public void add(T value, V priority) {
        def entry = new KeyEntry(
            value: value,
            priority: priority
        )
        this.list.add(entry)
        this.queue.add(entry)
    }
    public T pop() {
        def firstEntry = this.queue.poll()
        this.list.remove(firstEntry)
        return firstEntry.value
    }

    public boolean contains(T value) {
        return this.queue.contains(value)
    }

    public T removeElement(T value) { 

    }


    public boolean contains()



    private class KeyEntry implements Comparable<KeyEntry> {
        V priority
        T value

        @Override
        public int compareTo(KeyEntry other) {
            return this.priority.compareTo(other.priority)
        }

    }
}